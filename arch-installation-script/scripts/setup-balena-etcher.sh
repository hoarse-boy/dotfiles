#!/usr/bin/env bash
set -euo pipefail

# Configuration
APP_NAME="balena-etcher"
BASE_URL="https://github.com/balena-io/etcher/releases"
ICON_URL="https://github.com/balena-io/etcher/raw/master/assets/icon.png"
LOG_FILE="/tmp/balena-etcher-install.log"

# Initialize log file
echo "=== BalenaEtcher Installation Log ===" > "$LOG_FILE"
echo "Started at: $(date)" >> "$LOG_FILE"

# Log function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" | tee -a "$LOG_FILE"
}

# Cleanup function
cleanup() {
    if [ -f ~/.local/bin/"$APP_NAME".tmp ]; then
        log "Cleaning up temporary file"
        rm -f ~/.local/bin/"$APP_NAME".tmp >> "$LOG_FILE" 2>&1
    fi
}

# Register cleanup on exit
trap cleanup EXIT

# Create necessary directories
log "Creating directories"
mkdir -p ~/.local/bin >> "$LOG_FILE" 2>&1
mkdir -p ~/.local/share/applications >> "$LOG_FILE" 2>&1
mkdir -p ~/.local/share/icons/hicolor/256x256/apps >> "$LOG_FILE" 2>&1

# Function to get version from AppImage
get_appimage_version() {
    if [ -f "$1" ]; then
        log "Extracting version from: $1"
        local version_info
        version_info=$(strings "$1" 2>/dev/null | grep -a -m1 -oP 'BalenaEtcher \K\d+\.\d+\.\d+' || echo "0")
        log "Found version: $version_info"
        echo "$version_info"
        return 0
    fi
    echo "0"
    return 1
}

# Function to get latest version from GitHub
get_latest_version() {
    log "Fetching latest version from GitHub"
    local version
    version=$(curl -fLsS https://api.github.com/repos/balena-io/etcher/releases/latest | \
              grep -oP '"tag_name": "\Kv?\d+\.\d+\.\d+' | \
              sed 's/^v//' 2>> "$LOG_FILE")
    
    if [ -z "$version" ]; then
        log "Failed to get latest version from GitHub"
        echo "0"
        return 1
    fi
    log "Latest version on GitHub: $version"
    echo "$version"
}

# Check existing installation
log "Checking existing installation"
CURRENT_VERSION=$(get_appimage_version ~/.local/bin/"$APP_NAME")
if [ "$CURRENT_VERSION" != "0" ]; then
    log "Found existing version: $CURRENT_VERSION"
else
    log "No existing installation detected"
fi

# Get latest version
LATEST_VERSION=$(get_latest_version)
if [ "$LATEST_VERSION" == "0" ]; then
    log "Error: Could not determine latest version"
    exit 1
fi

# Version comparison and upgrade decision
UPGRADE=true
if [ "$CURRENT_VERSION" != "0" ] && [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then
    log "Update available: $CURRENT_VERSION -> $LATEST_VERSION"
    read -p "Upgrade from $CURRENT_VERSION to $LATEST_VERSION? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        UPGRADE=false
        log "User chose to skip upgrade"
    fi
elif [ "$CURRENT_VERSION" == "$LATEST_VERSION" ]; then
    UPGRADE=false
    log "Already on latest version"
fi

# Download if needed
if [ "$UPGRADE" = true ]; then
    log "Starting download process"
    
    # Try multiple download URLs
    DOWNLOAD_URLS=(
        "$BASE_URL/download/v$LATEST_VERSION/balenaEtcher-$LATEST_VERSION-x64.AppImage"
        "$BASE_URL/latest/download/balenaEtcher-x64.AppImage"
    )
    
    for url in "${DOWNLOAD_URLS[@]}"; do
        log "Attempting download from: $url"
        if wget --show-progress "$url" -O ~/.local/bin/"$APP_NAME".tmp >> "$LOG_FILE" 2>&1; then
            # Verify downloaded file contains version string
            if grep -aq "BalenaEtcher" ~/.local/bin/"$APP_NAME".tmp; then
                log "Download successful, moving to final location"
                mv -f ~/.local/bin/"$APP_NAME".tmp ~/.local/bin/"$APP_NAME" >> "$LOG_FILE" 2>&1
                chmod +x ~/.local/bin/"$APP_NAME" >> "$LOG_FILE" 2>&1
                DOWNLOAD_SUCCESS=true
                break
            else
                log "Downloaded file appears corrupted"
                rm -f ~/.local/bin/"$APP_NAME".tmp >> "$LOG_FILE" 2>&1
            fi
        else
            log "Download failed from: $url"
            rm -f ~/.local/bin/"$APP_NAME".tmp >> "$LOG_FILE" 2>&1
        fi
    done
    
    if [ "${DOWNLOAD_SUCCESS:-false}" != true ]; then
        log "Error: All download attempts failed"
        echo "Error: Failed to download BalenaEtcher. See $LOG_FILE for details."
        exit 1
    fi
fi

# Download icon if needed
if [ ! -f ~/.local/share/icons/hicolor/256x256/apps/etcher.png ]; then
    log "Downloading icon"
    wget --show-progress "$ICON_URL" -O ~/.local/share/icons/hicolor/256x256/apps/etcher.png >> "$LOG_FILE" 2>&1
fi

# Create/update desktop entry
log "Updating desktop entry"
cat > ~/.local/share/applications/"$APP_NAME".desktop <<EOF
[Desktop Entry]
Name=BalenaEtcher
Comment=Flash OS images to SD cards and USB drives
Exec=${HOME}/.local/bin/$APP_NAME
Icon=etcher
Terminal=false
Type=Application
Categories=Utility;Development;
StartupWMClass=balena-etcher-electron
EOF

# Create/update wrapper script
log "Updating wrapper script"
cat > ~/.local/bin/etcher <<EOF
#!/bin/sh
exec "${HOME}/.local/bin/$APP_NAME" "\$@"
EOF
chmod +x ~/.local/bin/etcher >> "$LOG_FILE" 2>&1

# Update desktop database
log "Updating desktop database"
update-desktop-database ~/.local/share/applications >> "$LOG_FILE" 2>&1

log "Installation completed successfully"
echo -e "\nInstallation complete!"
echo "Files in ~/.local/bin/:"
ls -lh ~/.local/bin/ | grep -E "balena-etcher|etcher"
echo -e "\nYou can now:"
echo "- Launch from terminal with: etcher"
echo "- Find it in your application menu as 'BalenaEtcher'"
echo "- Launch from Rofi by typing 'BalenaEtcher'"
echo -e "\nDetailed log available at: $LOG_FILE"
