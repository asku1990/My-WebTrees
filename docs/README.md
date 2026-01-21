# Webtrees Documentation

Welcome to the webtrees development documentation!

## 📚 Available Guides

### [Quick Start Cheat Sheet](cheatsheet.md)
The fastest way to find common commands. Perfect for daily use.

**Covers:**
- Start/stop commands
- Database operations
- Common troubleshooting
- Emergency fixes

### [Docker Commands](docker-commands.md)
Complete guide to managing Docker containers and volumes.

**Covers:**
- Starting and stopping services
- Cleaning and removing containers
- Database backup and restore
- Volume management
- Security configuration
- Troubleshooting Docker issues

### [Development Guide](development.md)
Full development workflow and best practices.

**Covers:**
- Initial setup
- Daily workflow
- Frontend development
- Testing and code quality
- Database management
- Debugging techniques
- Directory structure
- Contributing guidelines

---

## 🚀 Quick Start

### First Time Setup
```bash
# 1. Start MySQL
docker compose up -d

# 2. Install dependencies
composer install
pnpm install

# 3. Start webtrees
php -S localhost:8080 -t .

# 4. Open browser
open http://localhost:8080
```

### Database Credentials
- **Host**: 127.0.0.1
- **Port**: 3306
- **Database**: webtrees
- **User**: webtrees
- **Password**: webtrees
- **Prefix**: wt_

---

## 📖 Additional Resources

- **Official webtrees docs**: https://webtrees.net
- **GitHub**: https://github.com/fisharebest/webtrees
- **Contributing**: See `../CONTRIBUTING.md`
- **Demo**: https://dev.webtrees.net

---

## 💡 Tips

1. **Keep MySQL running** - You can leave the Docker container running all the time
2. **Use the cheat sheet** - Bookmark `cheatsheet.md` for quick reference
3. **Backup your data** - Run `docker exec webtrees_mysql mysqldump...` regularly
4. **Watch for changes** - Use `pnpm run watch` when developing CSS/JS

---

## 🆘 Need Help?

1. Check the **[Troubleshooting](#)** sections in each guide
2. Review **[cheatsheet.md](cheatsheet.md)** for quick fixes
3. Search the [webtrees forum](https://webtrees.net/forums)
4. Check [GitHub Issues](https://github.com/fisharebest/webtrees/issues)

---

*Last updated: January 2026*
