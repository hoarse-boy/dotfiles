# dotfiles setup guide

## prerequisites

before cloning this repository, make sure you have **git** and **gnu stow** installed.

### install git & stow

#### arch linux

```sh
sudo pacman -S git stow
```

#### macos (homebrew)

```sh
brew install git stow
```

---

## cloning and setting up

### 1. clone the repository

```sh
git clone --recursive https://github.com/hoarse-boy/dotfiles.git ~/my-dotfiles
```

---

### 2. navigate to the dotfiles directory

```sh
cd ~/my-dotfiles
```

---

### 3. symlink dotfiles

run the following commands to create symlinks:

```sh
bash stow-all.sh
```

#### 3.1 symlink specific files in hyprland machine

this is for stowing hyprland config files.

```sh
bash manage-hypr-files.sh
```

---

### 4. verify the symlinks

run:

```sh
ls -l ~/.config/
```

you should see **symlinks** pointing to `~/dotfiles/.config/`.

---

## updating and pushing changes

if you modify your dotfiles, commit and push them with:

```sh
git add .
git commit -m "updated dotfiles"
git push origin main
```

---

## additional notes

- to remove a symlinked folder without deleting the original files, use:

    ```sh
    bash remove-dotfiles.sh
    ```

- if you encounter permission errors, run `chown -R $USER:$USER ~/my-dotfiles/`.
