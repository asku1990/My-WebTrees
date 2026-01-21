# Webtrees Docker Commands

This guide covers all Docker commands needed to manage your webtrees development environment.

## Overview

Your setup uses:
- **MySQL 8.0** running in Docker
- **Webtrees** running locally with PHP development server
- **Data persistence** via Docker volumes

---

## 🚀 Starting Services

### Start MySQL (Docker)
```bash
cd /Users/akibeyondos/Documents/personal_projects/webtrees
docker compose up -d
```
- `-d` runs in detached mode (background)
- MySQL will be available at `localhost:3306`

### Start Webtrees (PHP Server)
```bash
cd /Users/akibeyondos/Documents/personal_projects/webtrees
php -S localhost:8080 -t .
```
- Access webtrees at `http://localhost:8080`
- Press `Ctrl+C` to stop

### Start Both Services (One Command)
```bash
cd /Users/akibeyondos/Documents/personal_projects/webtrees
docker compose up -d && php -S localhost:8080 -t .
```

---

## 🛑 Stopping Services

### Stop MySQL (Docker)
```bash
docker compose stop
```
- Stops containers but keeps them and their data

### Stop PHP Server
- Press `Ctrl+C` in the terminal where it's running
- Or find and kill the process:
```bash
lsof -ti:8080 | xargs kill
```

### Stop All Services
```bash
docker compose stop
# Then stop PHP server with Ctrl+C or kill command above
```

---

## 🗑️ Cleaning & Removing

### Remove Containers (Keep Data)
```bash
docker compose down
```
- Stops and removes containers
- **Preserves** MySQL data in volume
- Network is removed

### Remove Containers AND Data (Full Clean)
```bash
docker compose down -v
```
- **⚠️ WARNING:** This deletes ALL database data
- Removes containers, networks, AND volumes
- Use when you want a fresh start

### Remove Everything + Clean Docker
```bash
# Remove webtrees containers and volumes
docker compose down -v

# Remove dangling images (optional)
docker image prune -a

# Remove all unused volumes (optional, be careful!)
docker volume prune
```

---

## 🔄 Rebuilding

### Rebuild from Scratch

#### 1. Clean Everything
```bash
docker compose down -v
```

#### 2. Start Fresh
```bash
docker compose up -d
```

#### 3. Verify Database
```bash
docker exec -it webtrees_mysql mysql -u webtrees -pwebtrees -e "SHOW DATABASES;"
```

#### 4. Restart Webtrees
```bash
php -S localhost:8080 -t .
```

---

## 📊 Monitoring & Inspection

### Check Running Containers
```bash
docker ps
```

### Check All Containers (including stopped)
```bash
docker ps -a
```

### View MySQL Logs
```bash
docker logs webtrees_mysql
```

### Follow MySQL Logs (real-time)
```bash
docker logs -f webtrees_mysql
```

### View Container Stats (CPU, Memory)
```bash
docker stats webtrees_mysql
```

---

## 🔧 Database Operations

### Access MySQL Shell
```bash
docker exec -it webtrees_mysql mysql -u webtrees -pwebtrees webtrees
```

### Access MySQL Shell as Root
```bash
docker exec -it webtrees_mysql mysql -u root -prootpass
```

### Run SQL Command
```bash
docker exec -it webtrees_mysql mysql -u webtrees -pwebtrees webtrees -e "SELECT * FROM wt_user;"
```

### Backup Database
```bash
docker exec webtrees_mysql mysqldump -u webtrees -pwebtrees webtrees > backup_$(date +%Y%m%d_%H%M%S).sql
```

### Restore Database
```bash
docker exec -i webtrees_mysql mysql -u webtrees -pwebtrees webtrees < backup_file.sql
```

### Reset Database (Drop and Recreate)
```bash
docker exec -it webtrees_mysql mysql -u root -prootpass -e "DROP DATABASE IF EXISTS webtrees; CREATE DATABASE webtrees CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; GRANT ALL PRIVILEGES ON webtrees.* TO 'webtrees'@'%';"
```

---

## 🐛 Troubleshooting

### MySQL Container Won't Start
```bash
# Check logs
docker logs webtrees_mysql

# Remove and recreate
docker compose down
docker compose up -d
```

### Port 3306 Already in Use
```bash
# Find what's using the port
lsof -i :3306

# Kill the process
sudo kill -9 <PID>

# Or change port in docker-compose.yml
ports:
  - "3307:3306"  # Use 3307 externally
```

### Port 8080 Already in Use
```bash
# Find what's using the port
lsof -i :8080

# Kill the process
kill -9 <PID>

# Or use different port
php -S localhost:8081 -t .
```

### Can't Connect to Database from Webtrees
Check that:
1. MySQL container is running: `docker ps`
2. Use `127.0.0.1` NOT `localhost` in installer
3. Port is `3306`
4. Credentials match `docker-compose.yml`

### Data Directory Permission Issues
```bash
chmod -R 777 /Users/akibeyondos/Documents/personal_projects/webtrees/data
```

---

## 📦 Volume Management

### List Volumes
```bash
docker volume ls
```

### Inspect Volume
```bash
docker volume inspect webtrees_mysql_data
```

### Backup Volume Data
```bash
docker run --rm -v webtrees_mysql_data:/data -v $(pwd):/backup alpine tar czf /backup/mysql_backup.tar.gz -C /data .
```

### Restore Volume Data
```bash
docker run --rm -v webtrees_mysql_data:/data -v $(pwd):/backup alpine tar xzf /backup/mysql_backup.tar.gz -C /data
```

---

## 🔐 Security Notes

### Change Default Passwords

Edit `docker-compose.yml`:
```yaml
environment:
  MYSQL_ROOT_PASSWORD: your_secure_password_here
  MYSQL_PASSWORD: your_secure_password_here
```

Then rebuild:
```bash
docker compose down -v
docker compose up -d
```

---

## 📝 Quick Reference

| Task | Command |
|------|---------|
| Start MySQL | `docker compose up -d` |
| Stop MySQL | `docker compose stop` |
| Remove MySQL | `docker compose down` |
| Remove MySQL + Data | `docker compose down -v` |
| Start Webtrees | `php -S localhost:8080 -t .` |
| View logs | `docker logs webtrees_mysql` |
| MySQL shell | `docker exec -it webtrees_mysql mysql -u webtrees -pwebtrees webtrees` |
| Backup DB | `docker exec webtrees_mysql mysqldump -u webtrees -pwebtrees webtrees > backup.sql` |
| Check status | `docker ps` |

---

## 🌐 URLs

- **Webtrees**: http://localhost:8080
- **MySQL**: localhost:3306
- **phpMyAdmin** (if added): http://localhost:8081

---

## ⚙️ Configuration Files

- Docker config: `docker-compose.yml`
- PHP config: `/opt/homebrew/etc/php/8.5/php.ini`
- MySQL config: Inside container at `/etc/mysql/my.cnf`
- Webtrees data: `./data/`
