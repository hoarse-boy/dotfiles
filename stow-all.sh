#!/bin/bash

cd ~/my-dotfiles || exit 1  # exit if cd fails

EXCLUDE=(".ml4w-hyprland" "hypr" "arch-installation-script" ".git")  # list of directories to exclude

for package in */; do
  package_name="${package%/}"  # remove trailing slash

  # improved exclusion check
  if printf '%s\n' "${EXCLUDE[@]}" | grep -Fxq "$package_name"; then
    echo "Skipping excluded package: $package_name"
    continue
  fi

  echo "Stowing: $package_name"
  stow -v "$package_name"
done

