set -g fish_greeting

if status is-interactive
    starship init fish | source
end

zoxide init fish | source

# my_fav_pokemon
# fastfetch --logo-type kitty

# List Directory
alias ls="lsd"
alias l="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias lt="ls --tree"

# Personal
alias hypr-conf="cd ~/.config/hypr && nvim"
alias fish-conf="cd ~/.config/fish && nvim config.fish"
alias fastfetch="fastfetch --logo-type kitty"

# obsidian dir
alias oto="cd ~/google-drive/obsidian-vault/todos/ && nvim"
alias oin="cd ~/google-drive/obsidian-vault/inbox/ && nvim"

# zoxide
alias cd='z'

# git
alias config="/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"

# fish
abbr sf 'source ~/.config/fish/config.fish'

# abbreviation
# nvim
abbr v 'nvim'
abbr nv 'neovide --no-multigrid --fork --wayland_app_id neovide'
abbr lazy 'cd ~/.local/share/nvim/lazy/LazyVim/ && nvim'

# wezterm
abbr ws 'wezterm connect unix & disown & exit' # re attached or create new wezterm session if not exist.

# tmux 
abbr t 'tmux'
abbr ta 'tmux attach-session -t'
abbr tn 'tmux new-session -s'

# other most used commands
abbr dol 'nohup dolphin . > /dev/null 2>&1 &' # open dolphin for the current dir, quits terminal will not quit dolphin.
abbr lg 'lazygit'
abbr pwd 'pwd && pwd | wl-copy'

# FIX: need still to be updated.
# kubernetes
abbr kb 'kubectl'

# FIX: need still to be updated.
# docker
abbr dc 'docker'

# config abbreviation
abbr hc 'cd ~/.config/hypr && nvim userprefs.conf'
abbr fc 'cd ~/.config/fish && nvim config.fish'
abbr wc 'cd ~/.config/wezterm/ && nvim wezterm.lua'
abbr tc 'cd ~/.config/tmux/ && nvim tmux.conf'

# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr b 'cd ..'
abbr bb 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'

# yay abbr
abbr ys 'yay -S'
abbr yr 'yay -R'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
abbr mkdir 'mkdir -p'

# others
abbr e 'exit'
abbr c 'clear'
abbr vc 'code .'
abbr tree 'tree | wl-copy && tree'
abbr sy 'systemctl'
abbr sudo 'sudo -E'

# modify vim mode binding. location at .functions/fish_user_key_bindings.fish
set fish_key_bindings fish_user_key_bindings

set -Ux EDITOR nvim # currently only used when running crontab -e to open using nvim

# all of my files inside /bin is bash file and is an executable
set -x PATH "$HOME/bin/" $PATH

# opam configuration
source /home/jho/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# npm
set -U fish_user_paths (npm config get prefix)/bin $fish_user_paths

set -U fish_user_paths $HOME/.local/bin $fish_user_paths
