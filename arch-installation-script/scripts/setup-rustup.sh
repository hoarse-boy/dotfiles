#!/bin/bash

# Rust Environment Initialization Script

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Install rustup if not already installed
if ! command_exists rustup; then
  echo "Installing rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

  # Add Rust to the current shell session
  source "$HOME/.cargo/env"
else
  echo "rustup is already installed"
fi

# Set stable toolchain as default
echo "Setting stable toolchain as default..."
rustup default stable

# Update rustup and toolchains
echo "Updating rustup and toolchains..."
rustup update

# Add useful components
echo "Adding Rust components..."
rustup component add rustfmt clippy

# Verify installation
echo "Verifying Rust installation..."
rustc --version
cargo --version

echo -e "\nRust environment setup complete!"
