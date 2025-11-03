# 🔧 IMMEDIATE FIX - ALLOWED_HOSTS Error

## 🚨 You Got This Error:

```
Invalid HTTP_HOST header: '35.172.48.105:8000'. 
You may need to add '35.172.48.105' to ALLOWED_HOSTS.
```

---

## ✅ QUICK FIX (3 Steps)

### Step 1: Stop Containers

On your EC2, run:
```bash
docker-compose down
```

---

### Step 2: Re-upload Fixed docker-compose.yml

**On your local machine**:
```bash
cd Disease-Prediction-main
scp -i your-key.pem docker-compose.yml ubuntu@35.172.48.105:~/Disease-Prediction-main/
```

**This fixed file now includes `env_file: - .env`** so your .env will be loaded!

---

### Step 3: Restart

On EC2:
```bash
cd ~/Disease-Prediction-main
docker-compose up -d
```

**Wait 15 seconds**, then check: http://35.172.48.105:8000

---

## ✅ Alternative Fix (If you can't re-upload)

**On EC2, edit docker-compose.yml manually**:

```bash
cd ~/Disease-Prediction-main
nano docker-compose.yml
```

Find the `web:` section and add `env_file: - .env` line (around line 31):

**Before**:
```yaml
  web:
    build: .
    container_name: django_app
    command: sh -c "..."
    volumes:
      - .:/app
      - static_volume:/app/staticfiles
      - media_volume:/app/pics
    ports:
      - "8000:8000"
    depends_on:
      - db
    environment:          ← This line
      - DJANGO_SETTINGS_MODULE=disease_prediction.settings
```

**After**:
```yaml
  web:
    build: .
    container_name: django_app
    command: sh -c "..."
    volumes:
      - .:/app
      - static_volume:/app/staticfiles
      - media_volume:/app/pics
    ports:
      - "8000:8000"
    depends_on:
      - db
    env_file:             ← ADD THIS LINE
      - .env              ← ADD THIS LINE
    environment:          ← This line stays
      - DJANGO_SETTINGS_MODULE=disease_prediction.settings
```

Press `Ctrl+O` to save, `Enter` to confirm, `Ctrl+X` to exit.

Then restart:
```bash
docker-compose down
docker-compose up -d
```

---

## ✅ Another Quick Fix (Without editing)

Add ALLOWED_HOSTS directly to docker-compose environment:

```bash
cd ~/Disease-Prediction-main
nano docker-compose.yml
```

Find the `environment:` section under `web:` and add:

```yaml
    environment:
      - DJANGO_SETTINGS_MODULE=disease_prediction.settings
      - ALLOWED_HOSTS=35.172.48.105,localhost,127.0.0.1  ← ADD THIS
      - DB_HOST=db
      - DB_NAME=predico
      - DB_USER=postgres
      - DB_PASSWORD=postgresql
      - DB_PORT=5432
```

Save and restart.

---

## 🎯 Easiest Solution

**Just re-run the deployment script** - it now includes the fix:

```bash
cd ~/Disease-Prediction-main
docker-compose down
chmod +x deploy-simple.sh
./deploy-simple.sh
```

This will use the fixed docker-compose.yml with env_file support!

---

## ✅ Verify It Works

After restarting, check logs:
```bash
docker-compose logs -f web
```

Should not show ALLOWED_HOSTS errors.

Then visit: http://35.172.48.105:8000

**Should work now!** 🎉

