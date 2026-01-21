# Git Setup - Private Repository with Developer Updates

## 🎯 Overview

This setup allows you to maintain your own private webtrees repository while still being able to pull updates from the original developer once or twice a year.

```
origin    → YOUR private repo (github.com/YOUR-USERNAME/my-webtrees)
upstream  → Developer's repo  (github.com/fisharebest/webtrees)
```

---

## 📋 Initial Setup

### Step 1: Create Your Private GitHub Repository

1. Go to https://github.com/new
2. Repository name: `my-webtrees` (or your choice)
3. ✅ Check **"Private"**
4. ❌ Don't initialize with README
5. Click "Create repository"

### Step 2: Configure Git Remotes

```bash
# 1. Rename developer's repo to 'upstream'
git remote rename origin upstream

# 2. Add YOUR private repo as 'origin'
git remote add origin git@github.com:YOUR-USERNAME/my-webtrees.git
# Or use HTTPS: https://github.com/YOUR-USERNAME/my-webtrees.git

# 3. Verify setup
git remote -v
```

You should see:
```
origin    git@github.com:YOUR-USERNAME/my-webtrees.git (fetch)
origin    git@github.com:YOUR-USERNAME/my-webtrees.git (push)
upstream  https://github.com/fisharebest/webtrees.git (fetch)
upstream  https://github.com/fisharebest/webtrees.git (push)
```

### Step 3: Push Your Changes

```bash
# Push your current setup to your private repo
git push -u origin main
```

---

## 🔄 Daily Workflow

### Save Your Changes
```bash
git status                      # Check what changed
git add .                       # Stage changes
git commit -m "Update config"   # Commit
git push                        # Push to YOUR repo (origin)
```

### Pull Your Changes (on another machine)
```bash
git pull                        # Pull from YOUR repo (origin)
```

---

## 📥 Getting Developer Updates (Once a Year)

When the developer releases important updates:

```bash
# 1. Fetch developer's latest changes
git fetch upstream

# 2. Check what's new
git log HEAD..upstream/main --oneline

# 3. Pull the updates
git pull upstream main

# 4. If conflicts occur, resolve them, then:
git add .
git commit -m "Merge developer updates"

# 5. Push to YOUR repo
git push origin main
```

---

## 🚀 Server Deployment

### Initial Deployment

```bash
# On your VPS/server
git clone git@github.com:YOUR-USERNAME/my-webtrees.git webtrees
cd webtrees

# Start services
docker compose up -d
composer install --no-dev

# Visit your domain to complete setup
```

### Update Server

```bash
# On your VPS/server
cd webtrees
git pull
composer install --no-dev
docker compose restart
```

---

## 📁 What's in Your Private Repo

Your private repository contains:

✅ **Custom configuration:**
- `docker-compose.yml` - Your Docker setup
- `docs/` - Your documentation
- `pnpm-lock.yaml` - Your dependencies

✅ **Original webtrees code:**
- `app/` - PHP application
- `resources/` - Templates, translations
- `public/` - CSS, JS, images

❌ **Not included (gitignored):**
- `data/config.ini.php` - Database credentials
- `data/cache/` - Temporary files
- Family tree data (stored in MySQL)

---

## 🆘 Common Tasks

### Check if developer has updates
```bash
git fetch upstream
git log HEAD..upstream/main --oneline
```

### See your current remotes
```bash
git remote -v
```

### Switch back to developer's version (undo changes)
```bash
git fetch upstream
git reset --hard upstream/main
```

### See what files you've modified
```bash
git diff upstream/main
```

---

## 🔒 Security Notes

1. Keep `data/config.ini.php` private (already gitignored)
2. Never commit passwords or API keys
3. Your family tree data stays in MySQL (not in Git)
4. Your private repo can be cloned by your server only

---

## 💡 Quick Reference

| Task | Command |
|------|---------|
| Save changes | `git push` |
| Get your changes | `git pull` |
| Get developer updates | `git pull upstream main` |
| Check for updates | `git fetch upstream && git log HEAD..upstream/main` |
| Deploy to server | `git clone <your-repo>` |
| Update server | `git pull` |

---

**Remember:** Most of the time you work with `origin` (your repo). Only use `upstream` when getting developer updates.
