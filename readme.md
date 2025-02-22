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
git clone --recursive https://github.com/hoarse-boy/dotfiles.git ~/dotfiles
```

---

### 2. navigate to the dotfiles directory
```sh
cd ~/dotfiles
```

---

### 3. symlink dotfiles using stow
run the following commands to create symlinks:

```sh
stow bin
stow -t ~/.config .config
stow -t ~ gitconfig
stow -t ~ gitconfig_local
```

**explanation:**
- `stow bin` → symlinks `~/dotfiles/bin/` to `~/bin/`
- `stow -t ~/.config .config` → symlinks `~/dotfiles/.config/*` into `~/.config/`
- `stow -t ~ gitconfig` → symlinks `~/dotfiles/gitconfig` into `~/.gitconfig`.
- `~` is `$HOME` directory.

> [!NOTE]
> must follow stow naming convention for symlinks to work properly

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
  stow -D bin
  stow -D -t ~/.config .config
  ```
- if you encounter permission errors, run `chown -R $USER:$USER ~/dotfiles/`.

