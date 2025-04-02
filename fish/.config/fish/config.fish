set -g fish_greeting

if status is-interactive
    starship init fish | source
end

load_os_cmds

zoxide init fish | source

# makes the cursor change shape when in vim insert mode and normal mode
set -g fish_vi_force_cursor 1
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore

# List Directory
abbr ls lsd
abbr l "lsd -l"
abbr la "lsd -a"
abbr lla "lsd -la"
abbr lt "lsd --tree"

# zoxide
alias cd='z'

# fish
abbr sf 'source ~/.config/fish/config.fish'

# delta
abbr delta 'delta --pager=never'

# nvim
abbr v nvim
abbr lazy "cd ~/.local/share/nvim/lazy/LazyVim/ && $editor"

# ghostty
abbr ssh 'TERM=xterm-256color ssh ' # need the env TERM for ghostty to work as the delete button is not working.

# kitty
abbr kt 'kitten ssh'

# wezterm 
abbr ws 'wezterm connect unix & disown & exit' # re attached or create new wezterm session if not exist.

# tmux 
abbr t tmux
abbr ta 'tmux attach-session -t'
abbr tn 'tmux new-session -s'

# other most used commands
abbr lg lazygit

# TODO: add more for kubernetes
# kubernetes
abbr kb kubectl

# TODO: add more for docker
# docker
abbr dc docker

# config abbreviation
abbr hc "cd ~/.config/hypr && $editor userprefs.conf"
abbr fc "cd ~/.config/fish && $editor config.fish"
abbr gc "cd ~/.config/ghostty && $editor config"
abbr kc "cd ~/.config/kitty && $editor kitty.conf"
abbr wc "cd ~/.config/wezterm/ && $editor wezterm.lua"
abbr tc "cd ~/.config/tmux/ && $editor tmux.conf"
abbr nc "cd ~/.config/nvim/ && $editor lua/config/lazy.lua"

# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr b 'cd ..'
abbr bb 'cd ../..'
abbr bbb 'cd ../../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
abbr mkdir 'mkdir -p'

# others
abbr e exit
abbr c clear
abbr vc 'code .'
abbr sudo 'sudo -E'

# modify vim mode binding. location at .functions/fish_user_key_bindings.fish
set fish_key_bindings fish_user_key_bindings

set -Ux EDITOR nvim # currently only used when running crontab -e to open using nvim

# all of my files inside /bin is bash file and is an executable
set -x PATH "$HOME/bin/" $PATH

# opam configuration
source /home/jho/.opam/opam-init/init.fish >/dev/null 2>/dev/null; or true

# npm
set -U fish_user_paths (npm config get prefix)/bin $fish_user_paths

set -U fish_user_paths $HOME/.local/bin $fish_user_paths

# for luarock package magick to display image in nvim
set -x PATH $HOME/lua5.1/bin $PATH

