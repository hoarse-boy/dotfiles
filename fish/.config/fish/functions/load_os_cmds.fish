function load_os_cmds
    set -l os (uname)
    switch $os
        case Darwin
            # echo "macOS detected"
            # macOS specific commands
            source ~/.config/fish/macos.fish

            set -gx editor "neovide --frame buttonless --fork"

            abbr pwd 'pwd && pwd | pbcopy'
            abbr tree 'tree | pbcopy && tree'
            abbr nv 'neovide --frame buttonless --fork'

            set -Ux fish_user_paths (rbenv root)/shims $fish_user_paths

        case Linux
            # echo "Linux detected"
            # Linux specific commands
            set -gx editor "neovide --fork --wayland_app_id neovide" # or "nvim"

            # Personal
            alias fastfetch="fastfetch --logo-type kitty"

            abbr nv 'neovide --fork --wayland_app_id neovide' # no no-multigrid has better animation but will make the floating window to have dark background.
            abbr pwd 'pwd && pwd | wl-copy'
            abbr dol 'nohup dolphin . > /dev/null 2>&1 &' # open dolphin for the current dir, quits terminal will not quit dolphin.

            # pacman
            abbr -a p sudo pacman
            # abbr -a ps pacman -Ss # Search packages # this overwrite 'ps' command
            abbr -a pi sudo pacman -S # Install
            abbr -a pr sudo pacman -Rns # Remove + deps
            abbr -a pu sudo pacman -Syu # Full system update

            # yay
            abbr -a y yay
            abbr -a ys yay -S # Install from AUR
            abbr -a yr yay -Rns # Remove AUR package
            abbr -a yu yay -Syu # Update everything (AUR + official)

            abbr tree 'tree | wl-copy && tree'

            # systemd
            abbr -a s systemctl
            abbr -a sia systemctl --user is-active
            abbr -a ss systemctl --user status
            abbr -a sr systemctl --user restart
            abbr -a se systemctl --user enable
            abbr -a sd systemctl --user disable
            abbr -a sst systemctl --user start
            abbr -a sstp systemctl --user stop
            abbr -a log journalctl --user -u
            abbr -a jc journalctl --user -xe # Show full system logs

            # hyprland
            abbr -a h hyprctl
            abbr -a hd hyprctl dispatch # Dispatch commands (e.g., hd killactive)
            abbr -a hk hyprctl keyword # Change Hyprland settings
            abbr -a hr hyprctl reload # Reload config
            # abbr -a hw hyprpaper  # Hyprland wallpaper tool
            abbr -a wl wlogout # Wayland logout menu
            abbr -a clip wl-copy # Copy to clipboard
            abbr -a paste wl-paste # Paste from clipboard

            # trah-cli better rm. avoid deleting files to void.
            alias rm trash-put
            alias grep="rg"
            alias find="fd"

        case '*'
            echo "Unknown OS"
    end
end
