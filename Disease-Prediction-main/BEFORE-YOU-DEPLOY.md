# 🔍 Before You Deploy - Quick Checklist

## ✅ Check These in Your Existing .env File

### Critical Settings for Docker:

1. **DB_HOST** = `db` ⚠️ **IMPORTANT!**
   ```env
   DB_HOST=db  ✅ Correct for Docker Compose
   DB_HOST=localhost  ❌ Wrong for Docker
   ```

2. **ALLOWED_HOSTS** should include your EC2 IP
   ```env
   ALLOWED_HOSTS=35.172.48.105,localhost,127.0.0.1  ✅
   ```

3. **SECRET_KEY** should be a real secret key (not placeholder)
   ```env
   SECRET_KEY=your-actual-secret-key  ✅
   SECRET_KEY=your-secret-key-here  ❌ Placeholder
   ```

---

## 🔧 Quick Fix Commands

If you need to update your .env:

```bash
cd ~/Disease-Prediction-main

# Check current DB_HOST
grep DB_HOST .env

# If it shows DB_HOST=localhost, fix it:
sed -i 's/DB_HOST=localhost/DB_HOST=db/' .env

# Verify the change
grep DB_HOST .env

# Should show: DB_HOST=db
```

---

## 🚀 Then Just Deploy!

```bash
chmod +x deploy-simple.sh
./deploy-simple.sh
```

---

## 📋 Full .env Example

```env
# Django Settings
SECRET_KEY=django-insecure-xxxxxxxxx-change-this-to-real-key
DEBUG=False
ALLOWED_HOSTS=35.172.48.105,localhost,127.0.0.1

# Database Configuration (for Docker Compose)
DB_NAME=predico
DB_USER=postgres
DB_PASSWORD=postgresql
DB_HOST=db
DB_PORT=5432
```

---

## ⚠️ Most Common Mistake

**Don't use**:
```env
DB_HOST=localhost  ❌
```

**Use**:
```env
DB_HOST=db  ✅
```

The service name in docker-compose.yml is `db`, so that's what Django needs to connect.

---

**Now you're ready!** Just run `./deploy-simple.sh` 🚀

