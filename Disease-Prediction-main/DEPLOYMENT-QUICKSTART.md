# Quick Deployment Guide - Disease Prediction on AWS EC2

## 🚀 Fast Track Deployment (5 Minutes)

### Prerequisites
- AWS EC2 Instance running Ubuntu 20.04+
- SSH access to your instance

### Step 1: Upload Your Code

```bash
# On your local machine
scp -r -i your-key.pem Disease-Prediction-main ubuntu@your-ec2-ip:~/
```

### Step 2: SSH into EC2

```bash
ssh -i your-key.pem ubuntu@your-ec2-ip
```

### Step 3: Navigate and Configure

```bash
cd ~/Disease-Prediction-main

# Copy environment file
cp env.example .env

# Edit with your details
nano .env
```

Update these in `.env`:
```env
ALLOWED_HOSTS=your-ec2-public-ip
DB_PASSWORD=your-strong-password
```

### Step 4: Deploy!

```bash
# Make executable
chmod +x deploy.sh

# Run deployment
./deploy.sh
```

### Step 5: Access

Visit: **http://your-ec2-public-ip:8000**

---

## 📋 What Gets Deployed?

✅ PostgreSQL Database (Container)  
✅ Django Application  
✅ Gunicorn WSGI Server  
✅ WhiteNoise for Static Files  
✅ Auto-configured for AWS EC2  

---

## 🔧 Optional: Add Nginx (Recommended for Production)

```bash
docker-compose -f docker-compose.nginx.yml up -d --build
```

Then access via: **http://your-ec2-public-ip** (Port 80)

---

## 🛠️ Common Commands

```bash
# View logs
docker-compose logs -f

# Restart
docker-compose restart

# Stop
docker-compose down

# Create admin user
docker-compose exec web python manage.py createsuperuser

# Backup database
./backup.sh
```

---

## ⚠️ Important: Security Groups

In AWS Console, configure your security group:

| Port | Protocol | Source | Use |
|------|----------|--------|-----|
| 22   | TCP      | Your IP | SSH |
| 80   | TCP      | 0.0.0.0/0 | HTTP |
| 8000 | TCP      | 0.0.0.0/0 | Django |
| 5432 | TCP      | VPC CIDR | PostgreSQL |

---

## 🆘 Troubleshooting

**Can't access the application?**
- Check security groups
- Run `docker-compose logs` to see errors
- Verify port 8000 is open

**Database connection error?**
- Check `.env` file has correct DB_HOST
- Ensure PostgreSQL container is running: `docker-compose ps`

**Static files not loading?**
```bash
docker-compose exec web python manage.py collectstatic --noinput
```

---

## 📚 Full Documentation

For detailed information, see [README-DEPLOYMENT.md](README-DEPLOYMENT.md)

---

## ✨ Features

- ✅ Fully containerized with Docker
- ✅ PostgreSQL database included
- ✅ Production-ready Gunicorn server
- ✅ Environment-based configuration
- ✅ Automatic migrations
- ✅ Health checks and auto-restart
- ✅ Easy backup scripts
- ✅ Nginx integration ready

---

## 🎯 Next Steps

1. Set up SSL with Let's Encrypt
2. Configure domain name
3. Set up automated backups
4. Implement monitoring
5. Scale with load balancer

---

**Need Help?** Check the logs: `docker-compose logs -f`

