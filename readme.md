# **Dotfiles Setup & Usage Guide**  

This repo contains my personal dotfiles, managed with [ChezMoi](https://www.chezmoi.io). Follow these steps to set up your environment.  

---

## **📥 Install Dependencies**  

### **Arch Linux**  
```sh
sudo pacman -S git chezmoi
```

### **macOS**  
```sh
brew install git chezmoi
```

---

## **📂 Clone and Apply Dotfiles**  

### **First-time setup**  
```sh
chezmoi init --apply https://github.com/hoarse-boy/dotfiles.git
```

### **If ChezMoi is already initialized**  
```sh
rm -rf ~/.local/share/chezmoi/.git
git clone https://github.com/hoarse-boy/dotfiles.git ~/.local/share/chezmoi
chezmoi apply
```

### **Verify everything is set up correctly**  
```sh
chezmoi status
```

---

## **📌 Adding New Config Files to ChezMoi**  

### **Track a single file**  
```sh
chezmoi add ~/.bashrc
```

### **Track an entire folder manually**  
Since `chezmoi add --follow` does not work properly for symlinked folders, manually copy the real files:  
```sh
cp -r ~/.config/nvim ~/.local/share/chezmoi/
chezmoi add ~/.local/share/chezmoi/nvim
```

### **Commit and push the changes**  
```sh
chezmoi cd
git add .
git commit -m "Added new config files"
git push
```

---

## **🛠️ Managing Dotfiles**  

### **Check changes before applying**  
```sh
chezmoi diff
```

### **Apply all changes**  

- chezmoi apply → Copies files from ~/.local/share/chezmoi/ to your system (e.g., ~/.config/nvim/)

```sh
chezmoi apply
```

### **Edit a file inside ChezMoi storage**  
```sh
chezmoi edit ~/.bashrc
```

### **Update dotfiles from this repo**  

- pulls the latest changes from Git repository and apply

```sh
chezmoi update
```

---

## **🔥 Additional Notes**  

- ChezMoi stores dotfiles in `~/.local/share/chezmoi/`.
- To manually edit files before applying, navigate to:  
  ```sh
  chezmoi cd
  ```
