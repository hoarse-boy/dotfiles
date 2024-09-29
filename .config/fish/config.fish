set -g fish_greeting

if status is-interactive
    starship init fish | source
end

zoxide init fish | source

# makes the cursor change shape when in vim insert mode and normal mode
set -g fish_vi_force_cursor 1
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore

# List Directory
alias ls="lsd"
alias l="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias lt="ls --tree"

set -l editor "neovide --fork --wayland_app_id neovide" # or "nvim"

# Personal
alias fastfetch="fastfetch --logo-type kitty"

# obsidian dir
alias oto="cd ~/obsidian-syncthing/todos/ && $editor ."
alias oin="cd ~/obsidian-syncthing/inbox/ && $editor ."

# zoxide
alias cd='z'

# TODO: add others.
# git
alias cfg="/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"
abbr cfgs 'cfg status'
abbr cfga 'cfg add -u'
abbr cfgd 'cfg diff' # make sure ~/.gitconfig has the correct config to use delta. check ~/.gitconfig.template
abbr cfgr 'cfg restore' # to remove modified git files.
abbr cfgP 'cfg push'
abbr cfgp 'cfg pull'
abbr cfgc "GIT_DIR=$HOME/dotfiles GIT_WORK_TREE=$HOME cz c" # commit using commitizen.

# fish
abbr sf 'source ~/.config/fish/config.fish'

# abbreviation
# nvim
abbr v nvim
abbr nv 'neovide --fork --wayland_app_id neovide' # no no-multigrid has better animation but will make the floating window to have dark background.
# abbr nv 'neovide --no-multigrid --fork --wayland_app_id neovide'
abbr lazy "cd ~/.local/share/nvim/lazy/LazyVim/ && $editor"

# wezterm
abbr ws 'wezterm connect unix & disown & exit' # re attached or create new wezterm session if not exist.

# tmux 
abbr t tmux
abbr ta 'tmux attach-session -t'
abbr tn 'tmux new-session -s'

# other most used commands
abbr dol 'nohup dolphin . > /dev/null 2>&1 &' # open dolphin for the current dir, quits terminal will not quit dolphin.
abbr lg lazygit
abbr pwd 'pwd && pwd | wl-copy'

# TODO: add more for kubernetes
# kubernetes
abbr kb kubectl

# TODO: add more for docker
# docker
abbr dc docker

# config abbreviation
abbr hc "cd ~/.config/hypr && $editor userprefs.conf"
abbr fc "cd ~/.config/fish && $editor config.fish"
abbr wc "cd ~/.config/wezterm/ && $editor wezterm.lua"
abbr tc "cd ~/.config/tmux/ && $editor tmux.conf"

# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr b 'cd ..'
abbr bb 'cd ../..'
abbr bbb 'cd ../../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'

# yay abbr
abbr ys 'yay -S'
abbr yr 'yay -R'
# TODO: yay list packages.

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
abbr mkdir 'mkdir -p'

# others
abbr e exit
abbr c clear
abbr vc 'code .'
abbr tree 'tree | wl-copy && tree'
abbr sy systemctl
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
