# Using Your Existing .env File

## ✅ Perfect!

Since you already have a `.env` file, the deployment will use it directly.

---

## 🔍 What to Check in Your .env

Make sure your `.env` file has these settings:

```env
# Required for EC2 deployment
ALLOWED_HOSTS=35.172.48.105,localhost,127.0.0.1

# Database configuration for Docker
DB_HOST=db
DB_NAME=predico
DB_USER=postgres
DB_PASSWORD=postgresql
DB_PORT=5432

# Django settings
DEBUG=False
SECRET_KEY=your-actual-secret-key-here
```

---

## ⚠️ Important Notes

### For Docker Compose, `DB_HOST` should be `db`

Since we're using Docker Compose, the database hostname is `db` (the service name), not `localhost` or your EC2 IP.

If your `.env` currently has:
- ❌ `DB_HOST=localhost` → Change to `DB_HOST=db`
- ❌ `DB_HOST=35.172.48.105` → Change to `DB_HOST=db`

### ALLOWED_HOSTS should include your public IP

Make sure `ALLOWED_HOSTS` includes: `35.172.48.105`

---

## 🚀 Deploy Now

Just run the deployment script - it will use your existing .env:

```bash
cd ~/Disease-Prediction-main

# Deploy with your existing .env
chmod +x deploy-simple.sh
./deploy-simple.sh
```

Or use the regular deploy script:
```bash
chmod +x deploy.sh
./deploy.sh
```

---

## 📝 What the Script Will Do

The script will:
1. ✅ **Skip creating .env** (since you already have it)
2. ✅ **Update ALLOWED_HOSTS** with your detected EC2 IP (if different)
3. ✅ **Update DB_HOST to 'db'** if it's still localhost
4. ✅ **Build and deploy** your application

---

## 🎯 Quick Edit If Needed

If you need to edit your `.env` before deploying:

```bash
cd ~/Disease-Prediction-main
nano .env
```

**Make sure**:
- `DB_HOST=db` (important for Docker!)
- `ALLOWED_HOSTS=35.172.48.105,localhost,127.0.0.1`

Press `Ctrl+O` to save, `Enter` to confirm, `Ctrl+X` to exit.

---

## ✅ Ready to Deploy!

Since you already have `.env`, just run:

```bash
./deploy-simple.sh
```

That's it! Your existing configuration will be used. 🚀

