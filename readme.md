- [ ] update read me for nixos

- [ ] for dir config that has symlink or ever changing files like theme color. dont put into home manager

- [ ] clean up readme. make it readable

must run this manually

- `lsblk`
- `cfdisk`
- `mkfs`
- `mount`


## After `/mnt` + `/mnt/boot` are mounted:

Use one command.

## One-liner

 <!-- FIX: .  -->priority. check this

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/hoarse-boy/dotfiles/main/bootstrap.sh)
```




---


```bash
sudo nixos-rebuild switch --flake ~/dotfiles#jho
```
