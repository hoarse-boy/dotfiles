function load_os_cmds --description "Load OS-specific commands"
    if not command -q uname
        echo "Error: uname command not found" >&2
        return 1
    end

    set -l os (uname)
    switch $os
        case Darwin
            source ~/.config/fish/macos.fish
            set -gx editor "neovide --frame buttonless --fork"
            abbr pwd 'pwd && pwd | pbcopy'
            abbr tree 'tree | pbcopy && tree'
            abbr nv 'neovide --frame buttonless --fork'
            set -Ux fish_user_paths (rbenv root)/shims $fish_user_paths

        case Linux
            set -gx editor "neovide --fork --wayland_app_id neovide"

            abbr nv 'neovide --fork --wayland_app_id neovide'
            abbr pwd 'pwd && pwd | wl-copy'
            abbr dol 'nohup dolphin . > /dev/null 2>&1 &'
            abbr open 'setsid nautilus .'

            # yay package manager
            abbr y yay
            abbr ys 'yay -S'
            abbr yr 'yay -Rns'
            abbr yu 'yay -Syu'

            abbr tree 'tree | wl-copy && tree'

            # systemd
            abbr s systemctl
            abbr sia 'systemctl --user is-active'
            abbr sst 'systemctl --user status'
            abbr sre 'systemctl --user restart'
            abbr sen 'systemctl --user enable'
            abbr sdi 'systemctl --user disable'
            abbr sstr 'systemctl --user start'
            abbr sstp 'systemctl --user stop'
            abbr log 'journalctl --user -u'
            abbr jc 'journalctl --user -xe'

            # hyprland
            abbr h hyprctl
            abbr hd 'hyprctl dispatch'
            abbr hk 'hyprctl keyword'
            abbr hr 'hyprctl reload'
            abbr wl wlogout
            abbr clip wl-copy
            abbr paste wl-paste

            # safer rm, better grep and find
            alias rm trash-put
            alias grep rg
            alias find fd

            # npm
            alias cz czg
            set -gx PATH $HOME/.npm-global/bin $PATH
    end
end
