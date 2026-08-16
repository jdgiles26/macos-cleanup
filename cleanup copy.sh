#!/bin/bash

echo "Starting safe cleanup..."
echo "--------------------------"

# --- 1. Clean User Caches ---
# This is the safest and most effective location.
# Apps will recreate what they need.
echo "[1/4] Clearing user cache files from ~/Library/Caches/..."
rm -rfv ~/Library/Caches/*
echo "User caches cleared."
echo " "

# --- 2. Clean User Logs ---
# These are just log files, safe to delete.
echo "[2/4] Clearing user log files from ~/Library/Logs/..."
rm -rfv ~/Library/Logs/*
echo "User logs cleared."
echo " "

# --- 3. Clean Homebrew Cache (if installed) ---
# If you use Homebrew, this cleans old downloaded packages.
if command -v brew &> /dev/null; then
    echo "[3/4] Cleaning up Homebrew (brew)..."
    brew cleanup
else
    echo "[3/4] Homebrew not found, skipping."
fi
echo " "

# --- 4. Clean Docker Cache (if installed) ---
# This is a big one. It removes stopped containers and dangling images.
if command -v docker &> /dev/null; then
    echo "[4/4] Pruning Docker system..."
    docker system prune -f
else
    echo "[4/4] Docker not found, skipping."
fi
echo " "

echo "--------------------------"
echo "✅ Safe cleanup complete."
echo "Reminder: Don't forget to manually review your ~/Downloads folder and empty the Trash."