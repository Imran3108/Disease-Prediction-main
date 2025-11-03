# Disease Prediction - AWS EC2 Deployment Guide

This guide will walk you through deploying the Disease Prediction application on AWS EC2 using Docker.

## Prerequisites

1. AWS Account with EC2 instance running Ubuntu 20.04 or later
2. SSH access to your EC2 instance
3. Domain name (optional, for production)
4. Basic knowledge of AWS and Docker

## Architecture

The application consists of:
- **PostgreSQL Database**: Running in Docker container on EC2
- **Django Application**: Backend API and web interface
- **Nginx** (Optional): Reverse proxy for production

## Deployment Options

### Option 1: Simple Deployment (Development/Testing)

Uses `docker-compose.yml` - Includes Django and PostgreSQL only.

### Option 2: Production Deployment with Nginx

Uses `docker-compose.nginx.yml` - Includes Nginx reverse proxy for better performance.

## Step-by-Step Deployment

### 1. Launch EC2 Instance

1. Go to AWS EC2 Console
2. Launch a new instance:
   - **AMI**: Ubuntu Server 20.04 LTS or later
   - **Instance Type**: t2.medium or larger (minimum 2GB RAM)
   - **Storage**: 20GB minimum
   - **Security Group**: Create new with the following rules:
     - SSH (22) - from your IP
     - HTTP (80) - from anywhere
     - Custom TCP (8000) - from anywhere (for Django)
     - Custom TCP (5432) - only from your VPC (for PostgreSQL)

### 2. Connect to EC2 Instance

```bash
ssh -i your-key.pem ubuntu@your-ec2-public-ip
```

### 3. Upload Project Files

```bash
# On your local machine
scp -r -i your-key.pem Disease-Prediction-main ubuntu@your-ec2-public-ip:~/
```

Or use Git:
```bash
# On EC2 instance
cd ~
git clone your-repository-url
cd disease-prediction
```

### 4. Configure Environment Variables

```bash
# Copy the example environment file
cp env.example .env

# Edit with your settings
nano .env
```

Update the following in `.env`:
```env
SECRET_KEY=your-very-secure-secret-key-here
DEBUG=False
ALLOWED_HOSTS=your-ec2-public-ip,your-domain.com

DB_NAME=predico
DB_USER=postgres
DB_PASSWORD=strong-database-password-here
DB_HOST=db  # For docker-compose, use 'db'
DB_PORT=5432
```

### 5. Run Deployment Script

```bash
# Make the script executable
chmod +x deploy.sh

# Run deployment
./deploy.sh
```

Or manually:

```bash
# Make scripts executable
chmod +x deploy.sh

# For simple deployment (without Nginx)
docker-compose up -d --build

# For production with Nginx
docker-compose -f docker-compose.nginx.yml up -d --build
```

### 6. Configure Security Groups (Important!)

Update your EC2 security group:
- Port 22 (SSH): Only from your IP
- Port 80 (HTTP): From 0.0.0.0/0
- Port 8000 (Django direct access): From 0.0.0.0/0 (for testing)
- Port 5432 (PostgreSQL): Only from your VPC

### 7. Access Your Application

- **Without Nginx**: http://your-ec2-public-ip:8000
- **With Nginx**: http://your-ec2-public-ip

### 8. Create Superuser (Admin Account)

```bash
docker-compose exec web python manage.py createsuperuser
```

## Troubleshooting

### Check Container Logs

```bash
# View all logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f web
docker-compose logs -f db
```

### Restart Services

```bash
# Restart all
docker-compose restart

# Restart specific service
docker-compose restart web
```

### Stop and Remove Containers

```bash
docker-compose down

# Also remove volumes (CAUTION: deletes data)
docker-compose down -v
```

### Database Issues

```bash
# Access PostgreSQL container
docker-compose exec db psql -U postgres -d predico

# Create database backup
docker-compose exec db pg_dump -U postgres predico > backup.sql

# Restore database
cat backup.sql | docker-compose exec -T db psql -U postgres predico
```

### Static Files Issues

```bash
# Recollect static files
docker-compose exec web python manage.py collectstatic --noinput
```

## SSL/HTTPS Setup (Optional)

### Using Let's Encrypt with Certbot

1. Install Certbot on EC2:
```bash
sudo apt-get update
sudo apt-get install certbot python3-certbot-nginx -y
```

2. Get SSL certificate:
```bash
sudo certbot --nginx -d your-domain.com
```

3. Certificates renew automatically

## Backup Strategy

### Database Backup Script

Create `backup-db.sh`:
```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/home/ubuntu/backups"
mkdir -p $BACKUP_DIR

docker-compose exec -T db pg_dump -U postgres predico > $BACKUP_DIR/backup_$DATE.sql
echo "Backup completed: backup_$DATE.sql"
```

### Automated Backups (Cron)

```bash
# Edit crontab
crontab -e

# Add daily backup at 2 AM
0 2 * * * /home/ubuntu/backup-db.sh
```

## Monitoring

### Resource Usage

```bash
# Check container stats
docker stats

# Check disk usage
df -h
```

### Application Health

```bash
# Check if services are running
docker-compose ps

# Test Django endpoint
curl http://localhost:8000
```

## Scaling Considerations

For production with high traffic:

1. Use AWS RDS for PostgreSQL instead of containerized database
2. Use AWS ELB (Elastic Load Balancer) for load balancing
3. Implement Redis for caching
4. Use S3 for static/media file storage
5. Implement auto-scaling groups

## Cost Optimization

1. Use AWS Lightsail for simpler deployment (flat fee)
2. Use t3.micro for development/testing
3. Implement scheduled shutdown for non-production environments
4. Use EBS snapshots for backups (cheaper than full backups)

## Security Best Practices

1. ✅ Change default passwords
2. ✅ Use strong secret keys
3. ✅ Set DEBUG=False in production
4. ✅ Configure ALLOWED_HOSTS properly
5. ✅ Keep dependencies updated
6. ✅ Use HTTPS in production
7. ✅ Regular database backups
8. ✅ Monitor security groups
9. ✅ Use IAM roles instead of access keys when possible

## Support

For issues or questions:
1. Check Docker logs: `docker-compose logs`
2. Verify environment variables in `.env`
3. Check security group rules
4. Ensure ports are not blocked by firewall

## Additional Resources

- Docker Documentation: https://docs.docker.com/
- Django Deployment: https://docs.djangoproject.com/en/stable/howto/deployment/
- AWS EC2 Documentation: https://docs.aws.amazon.com/ec2/

