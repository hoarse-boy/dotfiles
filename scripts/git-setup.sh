#!/bin/bash

# Default values
DEFAULT_USER="hoarse-boy"
DEFAULT_EMAIL="jourdymagoofficial@gmail.com"

# Prompt for user details (default to pre-set values if empty)
echo "Enter your GitHub username [${DEFAULT_USER}]:"
read GITHUB_USER
GITHUB_USER=${GITHUB_USER:-$DEFAULT_USER}

echo "Enter your GitHub email [${DEFAULT_EMAIL}]:"
read GITHUB_EMAIL
GITHUB_EMAIL=${GITHUB_EMAIL:-$DEFAULT_EMAIL}

# Set up Git global config
git config --global user.name "$GITHUB_USER"
git config --global user.email "$GITHUB_EMAIL"
git config --global init.defaultBranch main
git config --global credential.helper store

echo "Git global config set for $GITHUB_USER ($GITHUB_EMAIL)!"

# Choose Authentication Method
echo "Choose authentication method (1 for HTTPS, 2 for SSH):"
read AUTH_METHOD

if [ "$AUTH_METHOD" == "1" ]; then
    # Set up HTTPS with Personal Access Token
    echo "Enter your GitHub Personal Access Token (PAT):"
    read -s GITHUB_PAT

    echo "https://$GITHUB_USER:$GITHUB_PAT@github.com" > ~/.git-credentials
    chmod 600 ~/.git-credentials

    echo "HTTPS authentication set up!"
elif [ "$AUTH_METHOD" == "2" ]; then
    # Set up SSH
    SSH_KEY_PATH="$HOME/.ssh/id_rsa"

    if [ -f "$SSH_KEY_PATH" ]; then
        echo "SSH key already exists!"
    else
        echo "Generating SSH key..."
        ssh-keygen -t rsa -b 4096 -C "$GITHUB_EMAIL" -f "$SSH_KEY_PATH" -N ""
        eval "$(ssh-agent -s)"
        ssh-add "$SSH_KEY_PATH"
        
        echo "Copy this SSH key and add it to GitHub under Settings > SSH and GPG keys:"
        cat "$SSH_KEY_PATH.pub"
        echo "Then press ENTER to continue."
        read
    fi

    echo "Testing SSH connection..."
    ssh -T git@github.com
fi
