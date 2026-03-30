#!/usr/bin/env bash

# exit on error
set -e

# variables
REPO_URL="https://codeberg.org/LGFae/awww"
CLONE_DIR="$HOME/awww"

# --- install dependencies ---
# install dav1d (required for avif)
if ! command -v dav1d >/dev/null 2>&1; then
    echo "installing dav1d..."

    if command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --needed dav1d
    elif command -v apt >/dev/null 2>&1; then
        sudo apt update
        sudo apt install -y dav1d libdav1d-dev
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y dav1d dav1d-devel
    else
        echo "unsupported package manager. install dav1d manually."
        exit 1
    fi
fi

# check cargo
if ! command -v cargo >/dev/null 2>&1; then
    echo "cargo not found. install rust first."
    exit 1
fi

# --- clone repo ---
echo "cloning awww..."
rm -rf "$CLONE_DIR"
git clone "$REPO_URL" "$CLONE_DIR"

cd "$CLONE_DIR"

# --- build & install ---
echo "installing awww client with avif..."
cargo install --path client --features=avif

echo "installing awww daemon..."
cargo install --path daemon

# --- cleanup ---
cd ~
rm -rf "$CLONE_DIR"

echo "done."
