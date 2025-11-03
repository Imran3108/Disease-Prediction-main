# ⚡ Quick Fix for Your Current Error

## The Problem

You got this error:
```
cp: cannot stat 'env.example': No such file or directory
```

This happened because the script was looking in the wrong directory.

## ✅ Solution 1: Manual Step-by-Step

Run these commands **one by one** on your EC2:

```bash
# 1. Find where you uploaded the files
ls -la ~/

# 2. Navigate to the project directory (whichever one exists)
cd ~/Disease-Prediction-main
# OR
cd ~/disease-prediction

# 3. Re-upload the fixed deploy.sh file from your local machine
# (On your local machine, run this:)
# scp -i your-key.pem deploy.sh ubuntu@35.172.48.105:~/Disease-Prediction-main/

# 4. Navigate to project
cd ~/Disease-Prediction-main

# 5. Copy env file
cp env.example .env

# 6. Edit .env if needed
nano .env

# 7. Make deploy script executable
chmod +x deploy.sh

# 8. Run deployment
./deploy.sh
```

---

## ✅ Solution 2: Manual Deployment (Without Script)

If you want to deploy manually:

```bash
# 1. Navigate to project
cd ~/Disease-Prediction-main

# 2. Create .env
cp env.example .env

# 3. Edit .env
nano .env
# Make sure ALLOWED_HOSTS=35.172.48.105,localhost,127.0.0.1
# Make sure DB_HOST=db (for Docker Compose)

# 4. Build containers
docker-compose build

# 5. Start containers
docker-compose up -d

# 6. Wait for database
sleep 10

# 7. Run migrations
docker-compose exec web python manage.py migrate --noinput

# 8. Collect static files
docker-compose exec web python manage.py collectstatic --noinput

# Done! Check your app at http://35.172.48.105:8000
```

---

## ✅ Solution 3: Update Deploy Script on EC2

```bash
# On your EC2, navigate to project
cd ~/Disease-Prediction-main

# Download/update the fixed deploy.sh
# OR manually edit it:

nano deploy.sh

# Find the line that says:
# PROJECT_DIR="/home/ubuntu/disease-prediction"

# Change it to auto-detect like this (use the full block from Solution 1)

# Save and exit (Ctrl+O, Enter, Ctrl+X)
# Then run:
chmod +x deploy.sh
./deploy.sh
```

---

## 📋 Current Directory Structure Check

Run this to see where your files are:

```bash
ls -la ~/
ls -la ~/Disease-Prediction-main/
```

You should see:
- Dockerfile
- docker-compose.yml
- env.example
- deploy.sh
- etc.

---

## 🎯 Quickest Fix

**Easiest way** - Just do manual deployment:

```bash
cd ~/Disease-Prediction-main
cp env.example .env
docker-compose up -d --build
docker-compose exec web python manage.py migrate
docker-compose exec web python manage.py collectstatic --noinput
```

Then access: **http://35.172.48.105:8000**

---

**Need help?** Tell me which step you're on and I'll guide you through it!

