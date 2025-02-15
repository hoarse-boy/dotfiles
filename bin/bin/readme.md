# Use Chmod to Give Permission to All Scripts in a Folder

```sh
chmod +x $HOME/bin
```

# Make Sure the Dir is Added to PATH

for fish.
```sh
set -x PATH "$HOME/bin/" $PATH
```

for bash.
```sh
export PATH=$PATH:/$HOME/bin/
```
