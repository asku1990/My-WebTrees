#!/bin/bash
# Setup script to configure your private repo as origin
# Developer's repo becomes upstream (for occasional updates)

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 Webtrees Private Repository Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "📍 Current remotes:"
git remote -v
echo ""

# Confirm before proceeding
read -p "This will rename 'origin' to 'upstream'. Continue? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Cancelled."
    exit 1
fi

# Get private repo URL
echo ""
echo "Please provide your PRIVATE GitHub repository URL."
echo "Example: git@github.com:yourusername/my-webtrees.git"
echo "     or: https://github.com/yourusername/my-webtrees.git"
echo ""
read -p "Your private repo URL: " PRIVATE_REPO

if [ -z "$PRIVATE_REPO" ]; then
    echo "❌ No URL provided. Exiting."
    exit 1
fi

echo ""
echo "🔄 Configuring remotes..."
echo ""

# Step 1: Rename origin to upstream
echo "1️⃣  Renaming 'origin' → 'upstream' (developer's repo)"
git remote rename origin upstream

# Step 2: Add private repo as origin
echo "2️⃣  Adding your private repo as 'origin'"
git remote add origin "$PRIVATE_REPO"

echo ""
echo "✅ Configuration complete!"
echo ""
echo "📍 New remotes:"
git remote -v
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Show what will be pushed
echo "📦 Your current changes to be pushed:"
git status --short
echo ""

read -p "Push these changes to your private repository now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "⬆️  Pushing to your private repository..."
    git push -u origin main
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🎉 Setup Complete!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "✅ Your changes are now in your private repo"
    echo "✅ You can deploy from: $PRIVATE_REPO"
else
    echo ""
    echo "⏸️  Push skipped. You can push later with:"
    echo "   git push -u origin main"
    echo ""
fi

echo ""
echo "📚 Daily usage:"
echo ""
echo "  Save your changes:"
echo "    git push"
echo ""
echo "  Get developer updates (once a year):"
echo "    git pull upstream main"
echo "    git push"
echo ""
echo "  Deploy to server:"
echo "    git clone $PRIVATE_REPO"
echo ""
echo "📖 For more info, see: docs/git-setup.md"
echo ""
