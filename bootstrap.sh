#!/usr/bin/env bash

set -euo pipefail

USERNAME="jho"
REPO="https://github.com/hoarse-boy/dotfiles.git"

if [[ $EUID -ne 0 ]]; then
  echo "run as root"
  exit 1
fi

if [[ -d "/home/${USERNAME}" ]]; then
  echo "installed system detected. aborting."
  exit 1
fi

if [[ -f /mnt/etc/nixos/hardware-configuration.nix ]]; then
  echo "/mnt already configured. aborting."
  exit 1
fi

echo "== NixOS ISO bootstrap only =="
echo
echo "== MANUAL REQUIRED FIRST =="
echo "lsblk"
echo "cfdisk /dev/nvme0n1"
echo "mkfs.fat -F32 -n BOOT /dev/nvme0n1p1"
echo "mkfs.ext4 -L nixos /dev/nvme0n1p2"
echo "mount /dev/nvme0n1p2 /mnt"
echo "mount --mkdir /dev/nvme0n1p1 /mnt/boot"
echo

read -rp "Type YES after partition + mount: " CONFIRM
[[ "$CONFIRM" == "YES" ]] || exit 1

read -rp "Hostname (default: jho): " HOSTNAME
HOSTNAME="${HOSTNAME:-jho}"

echo "== generate config =="
nixos-generate-config --root /mnt

echo "== clone dotfiles =="
nix-shell -p git --run "git clone ${REPO} /mnt/root/dotfiles"

echo "== write temporary loader =="
cat >/mnt/etc/nixos/configuration.nix <<EOF
{
  imports = [
    ./hardware-configuration.nix
    /root/dotfiles/nixos/configuration.nix
  ];
}
EOF

echo "== install =="
nixos-install --flake "/mnt/root/dotfiles#${HOSTNAME}"

echo "== set password =="
nixos-enter --root /mnt -c "passwd ${USERNAME}"

echo
echo "== reboot =="
echo "login as ${USERNAME}"
echo "run: bash ~/dotfiles/install.sh"
