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

        case Linux
            # echo "Linux detected"
            # Linux specific commands
            set -gx editor "neovide --fork --wayland_app_id neovide" # or "nvim"

            # Personal
            alias fastfetch="fastfetch --logo-type kitty"

            abbr nv 'neovide --fork --wayland_app_id neovide' # no no-multigrid has better animation but will make the floating window to have dark background.
            abbr pwd 'pwd && pwd | wl-copy'
            abbr dol 'nohup dolphin . > /dev/null 2>&1 &' # open dolphin for the current dir, quits terminal will not quit dolphin.

            # yay abbr
            abbr ys 'yay -S'
            abbr yr 'yay -R'
            # TODO: yay list packages.

            abbr tree 'tree | wl-copy && tree'
            abbr sy systemctl

        case '*'
            echo "Unknown OS"
    end
end
