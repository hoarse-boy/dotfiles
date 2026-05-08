#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
CHECKPOINT_DIR="$HOME/.setup-checkpoints"

mkdir -p "$CHECKPOINT_DIR"

done_step() {
  touch "$CHECKPOINT_DIR/$1"
}

is_done() {
  [[ -f "$CHECKPOINT_DIR/$1" ]]
}

if ! is_done hardware; then
  if [[ ! -f "$DOTFILES_DIR/nixos/hardware-configuration.nix" ]]; then
    cp /etc/nixos/hardware-configuration.nix "$DOTFILES_DIR/nixos/"
  fi
  done_step hardware
fi

if ! is_done rebuild; then
  cd "$DOTFILES_DIR"
  sudo nixos-rebuild switch --flake .#jho
  done_step rebuild
fi

# todo:
# stow
# hooks/install-npm-pkgs.sh
# restore restic
# restore rclone


# TODO:
# - run stow later
# - run hooks/install-npm-pkgs.sh
# - run hooks/setup-restic.sh after copying restic password
# - run hooks/setup-rclone.sh after copying rclone config
# - setup github.... etc
# - if ~/jho-notes empty, auto restore from restic backup
# - if media dirs empty, auto restore wallpapers/mp3 via rclone
