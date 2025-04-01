# dotfiles setup guide

## prerequisites

before cloning this repository, make sure you have **git** and **gnu stow** or **curl** installed.

### install git & stow

#### arch linux

```sh
sudo pacman -S git stow curl
```

#### macos (homebrew)

```sh
brew install git stow
```

## cloning and setting up

### linux

#### complete installation script (arch linux only)

Install [Hyprland](https://hyprland.org/) bootstraped by [ML4W](https://github.com/mylinuxforwork/dotfiles), stow dotfiles and run arch init scripts.

```bash
bash <(curl -sL https://raw.githubusercontent.com/hoarse-boy/dotfiles/main/install.sh)
```

the install.sh does the following:
- install ML4W and its dotfiles.
- stow dotfiles to home directory.
- install packages.
- run arch init scripts (systemd, setup commands, etc).

### macos

#### 1. clone the repository

```sh
git clone --recursive https://github.com/hoarse-boy/dotfiles.git ~/my-dotfiles
```

#### 2. navigate to the dotfiles directory

```sh
cd ~/my-dotfiles
```

#### 3. symlink dotfiles

run the following commands to create symlinks:

```sh
stow-all
```

#### 3.1 symlink specific files (optional)

this is for stowing hyprland config files.

```sh
manage-ml4w-config
```

#### 4. verify the symlinks

run:

```sh
ls -l ~/.config/
```

you should see **symlinks** pointing to `~/my-dotfiles/.config/`.

## additional notes

- to remove a symlinked folder without deleting the original files, use:

    ```sh
    remove-dotfiles
    ```

- if you encounter permission errors, run `chown -R $USER:$USER ~/my-dotfiles/`.
