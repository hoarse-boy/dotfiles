# Kitty Sessions

Simple session management for organizing terminal workspaces.

## What This Is

Instead of opening random terminals, you sessions to group related tasks together. Each session restores specific directories and layouts automatically.

## The Sessions

| File | Purpose | Window Class |
|------|---------|--------------|
| `kitty.session` | Default work terminal | `kitty` |
| `cf.session` | Config editing (hyprland, kitty, etc.) | `cf` |
| `tm.session` | Special workspace for running commands | `tm` |

## How to Use

### Create a Session File Using Kitty Binding

Create each tabs and rename it.

Click `ctrl+shift+s` to save the state of the current session.

The bash script `save-kitty-session.sh` will update the session file with the current directory and window layout.
Must be done on each kitty window.

### Create a Session File Manually

Write a `.session` file in the `sessions/` directory:

```
# Example: kitty.session
# Comments start with #

# Launch tabs with specific directories
new_tab
launch --cwd ~/projects/work

new_tab
launch --cwd ~/projects/another-repo

# Run commands on startup
# Useful for tailing logs or starting dev servers
new_tab
tail -f /var/log/syslog
```

Or check the `example.session` file.

### Launch a Session

This is done in Hyprland keybindings.

```bash
# Default work session
kitty --session sessions/kitty.session

# Config terminal (for editing dotfiles)
kitty --class cf --session sessions/cf.session

# Special workspace terminal
kitty --class tm --session sessions/tm.session
```
