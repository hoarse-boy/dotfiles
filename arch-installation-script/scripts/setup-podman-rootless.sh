#!/usr/bin/env bash
# Setup Podman for rootless operation (run after installation)
# Usage: ./setup-podman-rootless.sh

set -euo pipefail

# Enable user namespaces
echo "Configuring kernel for rootless containers..."
sudo mkdir -p /etc/sysctl.d
echo "kernel.unprivileged_userns_clone=1" | sudo tee /etc/sysctl.d/99-userns.conf >/dev/null
sudo sysctl -p /etc/sysctl.d/99-userns.conf

# Configure subuids/subgids
echo "Setting up subuids/subgids..."
sudo touch /etc/subuid /etc/subgid
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$USER"

# Configure rootless storage
echo "Creating Podman storage directories..."
mkdir -p \
  ~/.config/containers \
  ~/.local/share/containers/storage

echo 'driver = "overlay"' > ~/.config/containers/storage.conf

# Enable lingering for user services
echo "Enabling linger for user services..."
if ! command -v loginctl >/dev/null; then
  echo "WARNING: systemd-logind not found - cannot enable linger"
else
  loginctl enable-linger "$USER"
fi

# Verification
echo -e "\nVerification:"
podman info --format '{{.Host.Security.Rootless}}' | grep -q "true" && \
  echo "✔ Rootless mode configured successfully" || \
  echo "✖ Rootless setup failed"

echo "Try running: podman run --rm docker.io/library/hello-world"
