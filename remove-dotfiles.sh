#!/bin/bash

EXCLUDE=("hypr" "arch-installation-script" ".git")  # list of directories to exclude

echo "Choose an operation for the actual dotfiles in your home directory:"
echo "1) Remove (permanent deletion)"
echo "2) Rename (backup)"
echo "3) Unstow"
echo "4) Cancel"
read -r raw_choice

# Trim whitespace from the choice
choice="$(echo "$raw_choice" | xargs)"

if [[ $choice == "4" ]]; then
  echo "Operation cancelled."
  exit 0
fi

for package in ~/my-dotfiles/*/; do
  package_name="${package%/}"         # remove trailing slash
  package_name="${package_name##*/}"  # extract folder name

  # Skip excluded packages
  if printf '%s\n' "${EXCLUDE[@]}" | grep -Fxq "$package_name"; then
    echo "Skipping excluded package: $package_name"
    continue
  fi

  # Determine the correct target path dynamically
  if [[ -d "$package/.config" ]]; then
    # If the package contains a .config directory, place it in ~/.config
    target="$HOME/.config/$package_name"
  else
    # Otherwise, place it directly in the home directory
    target="$HOME/.$package_name"
  fi

  # Debugging: Print the target being checked
  echo "Checking target: $target"

  if [[ $choice == "1" ]]; then
    if [[ -e "$target" || -L "$target" ]]; then
      echo "Are you sure you want to permanently delete $target? (y/N)"
      read -r raw_confirm
      confirm="$(echo "$raw_confirm" | xargs | tr '[:upper:]' '[:lower:]')"
      if [[ "$confirm" == "y" || "$confirm" == "yes" ]]; then
        echo "Removing: $target"
        rm -rf "$target"  # Using rm -rf for both files/dirs and symlinks safely
      else
        echo "Skipping removal of $target"
      fi
    else
      echo "Skipping $target (not found)"
    fi

  elif [[ $choice == "2" ]]; then
    if [[ -e "$target" || -L "$target" ]]; then
      timestamp=$(date +"%Y%m%d_%H%M%S")  # generate unique timestamp
      new_name="${target}_old_${timestamp}"

      # Ensure uniqueness in case of duplicate timestamps
      counter=1
      while [[ -e "$new_name" || -L "$new_name" ]]; do
        new_name="${target}_old_${timestamp}_${counter}"
        ((counter++))
      done

      echo "Renaming $target -> $new_name"
      mv "$target" "$new_name"

    else
      echo "Skipping $target (not found)"
    fi

  elif [[ $choice == "3" ]]; then
    # Unstow the package using stow -D
    echo "Unstowing package: $package_name"
    stow -D "$package_name" 
  fi
done

if [[ $choice != "3" ]]; then
  echo "Run stow-all.sh to restore dotfiles."
fi


