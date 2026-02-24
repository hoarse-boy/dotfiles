#!/bin/bash

SOURCE="$HOME/my-dotfiles/limine/limine.conf"
DEST="/boot/limine.conf"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if source exists
if [ ! -f "$SOURCE" ]; then
    echo -e "${RED}Error: Source file $SOURCE not found${NC}"
    exit 1
fi

# Check if destination exists
if [ -f "$DEST" ]; then
    echo -e "${YELLOW}Warning: $DEST already exists${NC}"
    
    # Show diff
    echo -e "\n${YELLOW}Changes to be made:${NC}"
    sudo diff "$DEST" "$SOURCE" || echo "Files are identical"
    
    # Ask for confirmation
    echo -e "\n${YELLOW}Do you want to overwrite? (y/N) ${NC}"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo -e "${RED}Operation cancelled${NC}"
        exit 0
    fi
    
    # Create backup
    BACKUP="${DEST}.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}Creating backup: $BACKUP${NC}"
    sudo cp "$DEST" "$BACKUP"
fi

# Copy new config
echo -e "${GREEN}Installing new limine.conf${NC}"
sudo cp "$SOURCE" "$DEST"
sudo chmod 644 "$DEST"

echo -e "${GREEN}Done!${NC}"
