# 🚀 Your EC2 Deployment - Quick Reference

## Your EC2 Information

**Public IP**: `35.172.48.105`  
**Deployment URL**: `http://35.172.48.105:8000`

---

## ⚡ Quick Deployment Steps

### Step 1: Upload to EC2

On your local machine:
```bash
# Navigate to project folder
cd Disease-Prediction-main

# Upload to EC2 (replace your-key.pem with your actual key)
scp -r -i your-key.pem Disease-Prediction-main ubuntu@35.172.48.105:~/
```

### Step 2: SSH into EC2

```bash
ssh -i your-key.pem ubuntu@35.172.48.105
```

### Step 3: Navigate to Project

```bash
cd ~/Disease-Prediction-main
```

### Step 4: Configure Environment

```bash
# Copy environment template
cp env.example .env

# The ALLOWED_HOSTS is already set to your IP in env.example!
# Just edit if you need to change database password
nano .env
```

**env.example is already configured with your IP: 35.172.48.105**

### Step 5: Deploy!

```bash
# Make scripts executable
chmod +x deploy.sh

# Run automated deployment
./deploy.sh
```

This script will:
- ✅ Install Docker (if needed)
- ✅ Detect your EC2 IP automatically
- ✅ Build containers
- ✅ Run migrations
- ✅ Start services

### Step 6: Access Your App!

**Open in browser**: http://35.172.48.105:8000

---

## 🔐 Important: Security Group Configuration

**Before deploying**, configure your EC2 Security Group:

**Inbound Rules:**
- Port `22` (SSH) - Source: Your IP only
- Port `80` (HTTP) - Source: 0.0.0.0/0
- Port `8000` (Django) - Source: 0.0.0.0/0
- Port `5432` (PostgreSQL) - Source: VPC CIDR only

---

## 🛠️ Useful Commands

### After Deployment

```bash
# View logs
docker-compose logs -f

# Create admin user
docker-compose exec web python manage.py createsuperuser

# Restart services
docker-compose restart

# Stop everything
docker-compose down

# View running containers
docker-compose ps

# Backup database
./backup.sh

# Update configuration
./update-config.sh
```

---

## ✅ Verification Checklist

After deployment, verify:

- [ ] Can access: http://35.172.48.105:8000
- [ ] Homepage loads
- [ ] No 500 errors in browser
- [ ] Can create admin user
- [ ] Disease prediction works
- [ ] Database operations work

**Check logs**:
```bash
docker-compose logs -f
```

---

## 🐛 Troubleshooting

### Can't access application?

**Check 1**: Security Groups
```
AWS Console → EC2 → Security Groups
Ensure port 8000 is open to 0.0.0.0/0
```

**Check 2**: Container Status
```bash
docker-compose ps
# All should show "Up"
```

**Check 3**: View Logs
```bash
docker-compose logs -f web
# Look for errors
```

### Database connection error?

```bash
# Check database logs
docker-compose logs db

# Restart database
docker-compose restart db
```

### Static files not loading?

```bash
docker-compose exec web python manage.py collectstatic --noinput
docker-compose restart web
```

---

## 📊 Your Deployment Architecture

```
35.172.48.105 (AWS EC2)
├── Docker Containers
│   ├── django_app (Port 8000)
│   │   ├── Django Application
│   │   ├── Gunicorn Server
│   │   └── ML Model
│   └── postgres_db (Port 5432)
│       └── PostgreSQL Database
└── Accessible via: http://35.172.48.105:8000
```

---

## 🔄 Update Process

If you need to update your application:

```bash
# Pull latest changes
git pull

# Or re-upload files
scp -r -i your-key.pem Disease-Prediction-main ubuntu@35.172.48.105:~/

# Restart
docker-compose restart web

# Run migrations if needed
docker-compose exec web python manage.py migrate
```

---

## 🔒 Security Reminders

1. **Change default passwords** in production
2. **Set `DEBUG=False`** (already set in env.example)
3. **Use strong `SECRET_KEY`** (generate one!)
4. **Regular backups**: `./backup.sh`
5. **Keep updated**: `sudo apt-get update && sudo apt-get upgrade`

---

## 📚 More Help

- **Full Guide**: [README-DEPLOYMENT.md](README-DEPLOYMENT.md)
- **Quick Start**: [DEPLOYMENT-QUICKSTART.md](DEPLOYMENT-QUICKSTART.md)
- **Architecture**: [DOCKER-DEPLOYMENT-SUMMARY.md](DOCKER-DEPLOYMENT-SUMMARY.md)

---

## 🎉 Ready to Deploy!

Your configuration is ready. Just run:

```bash
./deploy.sh
```

**That's it!** Your app will be live at: **http://35.172.48.105:8000** 🚀

---

**Questions?** Check the logs: `docker-compose logs -f`

