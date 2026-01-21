# Deployment Guide - Self-Hosting Webtrees

## 🎯 Recommended Hosting: VPS

**Best providers for webtrees:**
- **DigitalOcean** - $6/month, easiest setup
- **Linode/Akakami** - $5/month
- **Hetzner** - €4.5/month (Europe)
- **Vultr** - $6/month

**Why VPS is best:**
- ✅ Full control over PHP, MySQL, Docker
- ✅ Use your own Git repository
- ✅ Simple `git pull` updates
- ✅ No platform limitations

---

## 🚀 Initial Server Setup

### 1. Create VPS

1. Sign up with provider
2. Create Ubuntu 24.04 LTS droplet/instance
3. Minimum specs: 1GB RAM, 1 CPU, 25GB storage
4. Note your server IP address

### 2. Connect to Server

```bash
ssh root@YOUR_SERVER_IP
```

### 3. Install Dependencies

```bash
# Update system
apt update && apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
apt install docker-compose-plugin -y

# Install PHP and Composer
apt install -y php8.3-cli php8.3-mysql php8.3-gd php8.3-intl \
    php8.3-mbstring php8.3-xml php8.3-curl php8.3-zip unzip git

# Install Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Install Nginx
apt install nginx -y

# Install Certbot (for SSL)
apt install certbot python3-certbot-nginx -y
```

---

## 📦 Deploy Webtrees

### 1. Clone Your Repository

```bash
# Create directory
cd /var/www
git clone git@github.com:YOUR-USERNAME/my-webtrees.git webtrees
cd webtrees
```

### 2. Start Services

```bash
# Start MySQL in Docker
docker compose up -d

# Install PHP dependencies
composer install --no-dev --optimize-autoloader

# Set permissions
chown -R www-data:www-data /var/www/webtrees
chmod -R 755 /var/www/webtrees
chmod -R 777 /var/www/webtrees/data
```

### 3. Configure Nginx

```bash
nano /etc/nginx/sites-available/webtrees
```

Add this configuration:

```nginx
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;
    
    root /var/www/webtrees;
    index index.php;
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    
    # Deny access to sensitive files
    location ~ /data/config.ini.php {
        deny all;
    }
    
    # Main location
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    
    # PHP handler
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
    
    # Deny access to .git
    location ~ /\.git {
        deny all;
    }
    
    # Cache static files
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff|woff2)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

Enable the site:

```bash
ln -s /etc/nginx/sites-available/webtrees /etc/nginx/sites-enabled/
nginx -t
systemctl reload nginx
```

### 4. Install SSL Certificate

```bash
certbot --nginx -d your-domain.com -d www.your-domain.com
```

### 5. Complete Webtrees Setup

Visit `https://your-domain.com` and complete the setup wizard:

- **Database host**: 127.0.0.1
- **Database port**: 3306
- **Database name**: webtrees
- **Database user**: webtrees
- **Database password**: webtrees
- **Table prefix**: wt_

---

## 🔄 Updating Webtrees

### From Your Local Machine

```bash
# Get developer updates (if needed)
git pull upstream main

# Push to your repo
git push
```

### On Your Server

```bash
ssh root@YOUR_SERVER_IP
cd /var/www/webtrees

# Pull latest changes
git pull

# Update dependencies
composer install --no-dev --optimize-autoloader

# Restart services if needed
docker compose restart
```

---

## 🔧 Maintenance Tasks

### Backup Database

```bash
# Create backup
docker exec webtrees_mysql mysqldump -u webtrees -pwebtrees webtrees > backup-$(date +%Y%m%d).sql

# Restore backup
docker exec -i webtrees_mysql mysql -u webtrees -pwebtrees webtrees < backup-20260121.sql
```

### Backup Data Folder

```bash
tar -czf data-backup-$(date +%Y%m%d).tar.gz /var/www/webtrees/data/
```

### View Logs

```bash
# Nginx logs
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log

# Docker logs
docker compose logs -f

# PHP logs
tail -f /var/log/php8.3-fpm.log
```

### Monitor Resources

```bash
# Disk space
df -h

# Memory usage
free -h

# Docker status
docker compose ps
```

---

## 🔒 Security Checklist

- ✅ Firewall configured (only 80, 443, 22 open)
- ✅ SSH key authentication enabled
- ✅ Password authentication disabled
- ✅ SSL certificate installed
- ✅ Regular backups scheduled
- ✅ Non-root user for deployments
- ✅ Fail2ban installed
- ✅ Automatic security updates enabled

### Setup Firewall

```bash
ufw allow 22
ufw allow 80
ufw allow 443
ufw enable
```

### Setup Auto-Updates

```bash
apt install unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades
```

---

## 🆘 Troubleshooting

### Webtrees shows 500 error

```bash
# Check PHP logs
tail -f /var/log/php8.3-fpm.log

# Check permissions
ls -la /var/www/webtrees/data/
```

### Database connection failed

```bash
# Check MySQL is running
docker compose ps

# Check credentials
cat /var/www/webtrees/data/config.ini.php
```

### Can't pull from Git

```bash
# Check Git credentials
git remote -v

# Re-authenticate
git config credential.helper store
git pull
```

---

## 📊 Performance Tuning

### PHP Configuration

Edit `/etc/php/8.3/fpm/php.ini`:

```ini
memory_limit = 256M
max_execution_time = 60
upload_max_filesize = 100M
post_max_size = 100M
```

Restart PHP-FPM:
```bash
systemctl restart php8.3-fpm
```

### MySQL Configuration

For better performance with larger family trees, tune MySQL settings in `docker-compose.yml`.

---

**Need help?** Check the webtrees forum: https://webtrees.net/forums
