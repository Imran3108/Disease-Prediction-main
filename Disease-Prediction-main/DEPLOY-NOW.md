# 🚀 DEPLOY NOW - Step by Step

## Your EC2 IP: **35.172.48.105**

Follow these steps **exactly**:

---

## Step 1: Re-upload Fixed Files to EC2

**On your local machine** (in the project folder):

```bash
cd Disease-Prediction-main

# Upload ALL files to EC2
scp -r -i your-key.pem . ubuntu@35.172.48.105:~/Disease-Prediction-main/
```

**Important:** Replace `your-key.pem` with your actual key file path.

---

## Step 2: SSH into EC2

```bash
ssh -i your-key.pem ubuntu@35.172.48.105
```

---

## Step 3: Navigate to Project

```bash
cd ~/Disease-Prediction-main
ls -la
```

You should see: Dockerfile, docker-compose.yml, env.example, etc.

---

## Step 4: Deploy (Choose One Method)

### Method A: Using the Simple Script (RECOMMENDED)

```bash
chmod +x deploy-simple.sh
./deploy-simple.sh
```

### Method B: Manual Deploy

```bash
# 1. Create .env file
cp env.example .env

# 2. Make sure .env has your IP (already configured!)
cat .env | grep ALLOWED_HOSTS

# 3. Build and start
docker-compose build
docker-compose up -d

# 4. Wait 15 seconds
sleep 15

# 5. Run migrations
docker-compose exec web python manage.py migrate --noinput

# 6. Collect static files
docker-compose exec web python manage.py collectstatic --noinput

# Done!
```

---

## Step 5: Verify

Open in browser: **http://35.172.48.105:8000**

---

## Step 6: Create Admin User

```bash
docker-compose exec web python manage.py createsuperuser
```

Follow the prompts to create your admin account.

---

## 🐛 Troubleshooting

### Can't access the website?

**Check security group**:
- Go to AWS Console → EC2 → Security Groups
- Make sure port 8000 is open to 0.0.0.0/0

**Check containers**:
```bash
docker-compose ps
```

All should show "Up" status.

**View logs**:
```bash
docker-compose logs -f
```

### Database errors?

```bash
docker-compose logs db
docker-compose restart db
```

### Static files not loading?

```bash
docker-compose exec web python manage.py collectstatic --noinput
docker-compose restart web
```

---

## ✅ Success Indicators

You'll know it worked when:

- ✅ Browser shows your homepage at http://35.172.48.105:8000
- ✅ No 500 errors
- ✅ Disease prediction page loads
- ✅ Can create admin user

---

## 📊 Quick Commands Reference

```bash
# View logs
docker-compose logs -f

# Stop everything
docker-compose down

# Restart
docker-compose restart

# View running containers
docker-compose ps

# Shell access
docker-compose exec web bash

# Backup database
./backup.sh

# Check what's running
docker ps
```

---

## 🎯 That's It!

Your application should now be live at:
**http://35.172.48.105:8000**

---

**Questions?** Check the logs: `docker-compose logs -f`

