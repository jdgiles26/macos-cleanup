#!/bin/zsh

# ----------------------------------------------
# SECTION 1: SYSTEM & USER DATA CLEAN-UP
# ----------------------------------------------

echo "Starting system cleanup and cache removal..."

# 1. Clear User Caches
# These are temporary files and can safely be deleted.
echo "Clearing User Caches..."
rm -rf ~/Library/Caches/*

# 2. Clear System Caches
# Requires administrator privileges (sudo).
echo "Clearing System Caches..."
sudo rm -rf /Library/Caches/*
sudo rm -rf /System/Library/Caches/*

# 3. Clean Log Files
# These files record system activity and can grow large.
echo "Cleaning system logs..."
sudo rm -rf /private/var/log/*

# 4. Clear Crash Reports
# Removes crash logs and diagnostic reports.
echo "Clearing diagnostic/crash reports..."
rm -rf ~/Library/Logs/DiagnosticReports/*
sudo rm -rf /Library/Logs/DiagnosticReports/*

# 5. Clear Download History Metadata
# Clears the history of files downloaded from the internet.
echo "Clearing quarantine data..."
sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2 "delete from LSQuarantineEvent"

# 6. Clear Thumbnail Cache (QuickLook)
# Deletes cached thumbnails for files.
echo "Clearing QuickLook cache..."
qlmanage -r cache

# 7. Clear Xcode Derived Data (if applicable)
# Developers often have massive amounts of derived data.
if [ -d ~/Library/Developer/Xcode/DerivedData ]; then
    echo "Clearing Xcode Derived Data..."
    rm -rf ~/Library/Developer/Xcode/DerivedData/*
fi

# ----------------------------------------------
# SECTION 2: NETWORK & SYSTEM SECURITY
# ----------------------------------------------

echo "Applying network and security configurations..."

# 8. Reset DNS Cache
# Forces your Mac to re-fetch DNS records, can resolve networking issues and remove stale data.
echo "Flushing DNS cache..."
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

# 9. Disable Guest User Login (Security)
# Prevents unauthorized access from the login screen.
echo "Disabling Guest User Login..."
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool NO

# 10. Disable Remote Apple Events (Security)
# Prevents unauthorized remote access to launch apps and run scripts.
echo "Disabling Remote Apple Events..."
sudo systemsetup -setremoteappleevents off

# 11. Disable Remote Login (SSH) if not needed (Security)
# If you don't use SSH, keep it disabled.
echo "Disabling Remote Login (SSH)..."
sudo systemsetup -setremotelogin off

# ----------------------------------------------
# SECTION 3: SYSTEM MAINTENANCE & VERIFICATION
# ----------------------------------------------

# 12. Run Maintenance Scripts
# Executes daily, weekly, and monthly Unix maintenance scripts.
echo "Running standard Unix maintenance scripts..."
sudo periodic daily weekly monthly

# 13. Rebuild Spotlight Index Metadata
# Clears and rebuilds the Spotlight search index, removing old/unused metadata.
echo "Rebuilding Spotlight metadata (This may take a while)..."
sudo mdutil -E /

echo "----------------------------------------------"
echo "Cleanup and Security script finished!"
echo "A system restart is recommended to fully realize changes."
echo "----------------------------------------------"
