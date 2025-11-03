# ✅ AWS EC2 Deployment Checklist

Use this checklist to ensure a smooth deployment of your Disease Prediction application.

## 📋 Pre-Deployment Checklist

### AWS EC2 Setup
- [ ] AWS account created and configured
- [ ] EC2 instance launched (Ubuntu 20.04+)
- [ ] Instance type selected (t2.medium or larger)
- [ ] Security group created
- [ ] Key pair created and downloaded
- [ ] SSH access tested
- [ ] Elastic IP assigned (optional, for static IP)

### Security Group Configuration
- [ ] Port 22 (SSH) - from your IP only
- [ ] Port 80 (HTTP) - from 0.0.0.0/0
- [ ] Port 8000 (Django) - from 0.0.0.0/0
- [ ] Port 5432 (PostgreSQL) - from VPC CIDR only (optional)
- [ ] Security group rules applied

### Local Preparation
- [ ] Project code updated
- [ ] All commits pushed to repository
- [ ] Environment variables documented
- [ ] Database backup created (if upgrading)

---

## 🚀 Deployment Steps

### Step 1: Connect to EC2
- [ ] SSH into instance
  ```bash
  ssh -i your-key.pem ubuntu@your-ec2-ip
  ```

### Step 2: Upload Project
- [ ] Project uploaded to EC2 (via Git or SCP)
  ```bash
  # Option 1: Git
  git clone <repository-url>
  
  # Option 2: SCP
  scp -r -i your-key.pem Disease-Prediction-main ubuntu@ec2-ip:~/
  ```

### Step 3: Configure Environment
- [ ] Navigate to project directory
  ```bash
  cd Disease-Prediction-main
  ```
- [ ] Create .env file
  ```bash
  cp env.example .env
  ```
- [ ] Edit .env with your settings
- [ ] Update ALLOWED_HOSTS with EC2 public IP
- [ ] Set strong SECRET_KEY
- [ ] Set DEBUG=False
- [ ] Configure database credentials

### Step 4: Install Dependencies
- [ ] Docker installed
- [ ] Docker Compose installed
- [ ] Current user added to docker group
- [ ] Docker daemon running

### Step 5: Deploy Application
- [ ] Deployment script made executable
  ```bash
  chmod +x deploy.sh
  ```
- [ ] Deployment script executed
  ```bash
  ./deploy.sh
  ```
- [ ] Build completed successfully
- [ ] Containers started
- [ ] No errors in logs

---

## ✅ Post-Deployment Checklist

### Service Verification
- [ ] Docker containers running
  ```bash
  docker-compose ps
  ```
- [ ] Application accessible via browser
  - [ ] Home page loads
  - [ ] No 500 errors
  - [ ] Static files loading
  - [ ] Images displaying
- [ ] Database connection working
- [ ] Admin panel accessible

### Security Checklist
- [ ] DEBUG=False in production
- [ ] Strong SECRET_KEY set
- [ ] ALLOWED_HOSTS configured correctly
- [ ] Default passwords changed
- [ ] Security group rules restrictive
- [ ] Regular backup scheduled
- [ ] SSL/HTTPS configured (optional)

### Testing Checklist
- [ ] Patient registration works
- [ ] Doctor registration works
- [ ] Disease prediction functional
- [ ] Consultation creation works
- [ ] Chat messaging works
- [ ] File uploads work
- [ ] Admin panel functional
- [ ] All forms submit correctly

### Database Checklist
- [ ] Migrations applied
  ```bash
  docker-compose exec web python manage.py migrate
  ```
- [ ] Superuser created
  ```bash
  docker-compose exec web python manage.py createsuperuser
  ```
- [ ] Sample data tested (if needed)
- [ ] Database backup tested
  ```bash
  ./backup.sh
  ```

### Monitoring Checklist
- [ ] Container logs monitored
  ```bash
  docker-compose logs -f
  ```
- [ ] Disk space adequate
  ```bash
  df -h
  ```
- [ ] Memory usage acceptable
  ```bash
  docker stats
  ```
- [ ] CPU usage normal

---

## 🔧 Optional Enhancements

### Production Features
- [ ] Nginx reverse proxy installed
  ```bash
  docker-compose -f docker-compose.nginx.yml up -d
  ```
- [ ] SSL certificate installed (Let's Encrypt)
- [ ] Domain name configured
- [ ] CDN for static files (CloudFront)
- [ ] Load balancer configured (ALB)
- [ ] Auto-scaling enabled
- [ ] CloudWatch monitoring

### Backup & Recovery
- [ ] Automated backup cron job
  ```bash
  crontab -e
  # Add: 0 2 * * * /path/to/backup.sh
  ```
- [ ] Backup restoration tested
- [ ] Disaster recovery plan documented
- [ ] S3 backup configured (optional)

### Performance
- [ ] Redis caching configured
- [ ] Database indexing optimized
- [ ] Static files CDN enabled
- [ ] Image optimization
- [ ] Database connection pooling
- [ ] Worker processes tuned

---

## 🐛 Troubleshooting Log

Document any issues encountered:

| Issue | Solution | Status |
|-------|----------|--------|
|       |          |        |
|       |          |        |
|       |          |        |

---

## 📊 Health Check Schedule

Daily checks:
- [ ] Application responding
- [ ] Container status
- [ ] Disk usage
- [ ] Recent errors in logs

Weekly checks:
- [ ] Backup verification
- [ ] Security updates
- [ ] Performance metrics
- [ ] User feedback review

Monthly checks:
- [ ] Full system backup
- [ ] Dependency updates
- [ ] Security audit
- [ ] Cost optimization review

---

## 📞 Support Resources

- **Project Documentation**: README.md
- **Quick Start**: DEPLOYMENT-QUICKSTART.md
- **Full Guide**: README-DEPLOYMENT.md
- **Architecture**: DOCKER-DEPLOYMENT-SUMMARY.md
- **Django Docs**: https://docs.djangoproject.com
- **Docker Docs**: https://docs.docker.com
- **AWS EC2 Docs**: https://docs.aws.amazon.com/ec2

---

## 🎉 Deployment Complete!

Once all items are checked:
- [ ] Share application URL with stakeholders
- [ ] Monitor for 24 hours
- [ ] Update documentation with actual IPs
- [ ] Celebrate! 🚀

---

**Last Updated**: $(date)
**Deployed By**: _________________
**Deployment Date**: _________________

