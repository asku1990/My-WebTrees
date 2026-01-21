# Quick Commands

## Start
```bash
docker compose up -d && php -S localhost:8080 -t .
```

## Stop
```bash
# Ctrl+C for PHP server
docker compose stop
```

## Database Shell
```bash
docker exec -it webtrees_mysql mysql -u webtrees -pwebtrees webtrees
```

## Backup Database
```bash
docker exec webtrees_mysql mysqldump -u webtrees -pwebtrees webtrees > backup.sql
```

## Restore Database
```bash
docker exec -i webtrees_mysql mysql -u webtrees -pwebtrees webtrees < backup.sql
```

## Reset Everything
```bash
docker compose down -v
docker compose up -d
rm -rf data/cache data/sessions data/config.ini.php
```

## Kill PHP Server
```bash
lsof -ti:8080 | xargs kill
```

## Update Code
```bash
git pull && composer install
```

## Run Tests
```bash
vendor/bin/phpunit
```

## Check Status
```bash
docker ps
lsof -i :8080
```

## URLs
- Webtrees: http://localhost:8080
- MySQL: 127.0.0.1:3306 (user: webtrees, pass: webtrees)
