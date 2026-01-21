# Webtrees Development Guide

## 🛠️ Initial Setup

### 1. Install PHP Dependencies
```bash
composer install
```

### 2. Start Database
```bash
docker compose up -d
```

### 3. Start Development Server
```bash
php -S localhost:8080 -t .
```

### 4. Open Browser
Go to http://localhost:8080

**Database credentials:**
- Host: `127.0.0.1`
- Port: `3306`
- Database: `webtrees`
- User: `webtrees`
- Password: `webtrees`
- Prefix: `wt_`

---

## 🔄 Daily Workflow

### Start
```bash
docker compose up -d
php -S localhost:8080 -t .
```

### Stop
Press `Ctrl+C` (PHP server)
```bash
docker compose stop  # optional
```

### Update Code
```bash
git pull
composer install
```

---

## 🗄️ Database

### Access MySQL
```bash
docker exec -it webtrees_mysql mysql -u webtrees -pwebtrees webtrees
```

### Backup
```bash
docker exec webtrees_mysql mysqldump -u webtrees -pwebtrees webtrees > backup.sql
```

### Restore
```bash
docker exec -i webtrees_mysql mysql -u webtrees -pwebtrees webtrees < backup.sql
```

### Reset Database
```bash
docker exec -it webtrees_mysql mysql -u root -prootpass -e "DROP DATABASE webtrees; CREATE DATABASE webtrees CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
rm -rf data/cache data/sessions data/config.ini.php
```

---

## 🧪 Testing

### Run Tests
```bash
vendor/bin/phpunit
```

---

## 🐛 Debugging

### Clear Cache
```bash
rm -rf data/cache/*
```

### Check Ports
```bash
lsof -i :8080
lsof -i :3306
```

### Kill Process
```bash
lsof -ti:8080 | xargs kill
```

---

## 📁 Key Directories

- `app/` - Application code
- `data/` - Webtrees data (gitignored)
- `public/` - Web root (already built)
- `resources/` - Source files
- `vendor/` - PHP dependencies

**Note:** `public/css/` and `public/js/` are pre-built and committed. Don't need to rebuild.
