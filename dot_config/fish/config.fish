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

# obsidian dir
# alias oto="cd ~/obsidian-syncthing/todos/ && $editor ."
# alias oin="cd ~/obsidian-syncthing/inbox/ && $editor ."

# zoxide
alias cd='z'

# git bare
# alias cfg="/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"
# abbr cfgs 'cfg status'
# abbr cfga 'cfg add -u'
# abbr cfgd 'cfg diff' # make sure ~/.gitconfig has the correct config to use delta. check ~/.gitconfig.template
# abbr cfgA 'cfg add .' # add new files inside dirs. for example add new file in nvim dir. carefull as this can add all files in the dir.
# abbr cfgr 'cfg restore' # to remove modified git files.
# abbr cfgps 'cfg push'
# abbr cfgp 'cfg pull'
# abbr cfgc "GIT_DIR=$HOME/dotfiles GIT_WORK_TREE=$HOME cz c" # commit using commitizen.

# fish
abbr sf 'source ~/.config/fish/config.fish'

# chezmoi
abbr cm chezmoi
# abbr cme 'chezmoi edit' # TODO: chezmoi cd && chezmoi edit ?
abbr cma 'chezmoi add'
abbr cmA 'chezmoi apply'
abbr cmd 'chezmoi -v diff'
abbr cmU 'chezmoi update' # pull from git remote and apply
abbr cms 'chezmoi status'
abbr cmc 'chezmoi cd'

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
# NOTE: commented out as editing dotfiles must directly be done inside chezmoi directory
# abbr hc "cd ~/.config/hypr && $editor userprefs.conf"
# abbr fc "cd ~/.config/fish && $editor config.fish"
# abbr gc "cd ~/.config/ghostty && $editor config"
# abbr kc "cd ~/.config/kitty && $editor kitty.conf"
# abbr wc "cd ~/.config/wezterm/ && $editor wezterm.lua"
# abbr tc "cd ~/.config/tmux/ && $editor tmux.conf"
# abbr nc "cd ~/.config/nvim/ && $editor lua/config/lazy.lua"

abbr hc "cd ~/.local/share/chezmoi/dot_config/hypr && $editor userprefs.conf"
abbr fc "cd ~/.local/share/chezmoi/dot_config/fish && $editor config.fish"
abbr gc "cd ~/.local/share/chezmoi/dot_config/ghostty && $editor config"
abbr kc "cd ~/.local/share/chezmoi/dot_config/kitty && $editor kitty.conf"
abbr wc "cd ~/.local/share/chezmoi/dot_config/wezterm && $editor wezterm.lua"
abbr tc "cd ~/.local/share/chezmoi/dot_config/tmux && $editor tmux.conf"
abbr nc "cd ~/.local/share/chezmoi/dot_config/nvim && $editor lua/config/lazy.lua"
abbr de "cd ~/.local/share/chezmoi && $editor" # to edit chezmoi dotfiles using neovide

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
# set -Ux LUA_PATH "$HOME/lua5.1/share/lua/5.1/?.lua;./?.lua;$HOME/lua5.1/share/lua/5.1/?/init.lua;$HOME/.luarocks/share/lua/5.1/?.lua;$HOME/.luarocks/share/lua/5.1/?/init.lua"
# set -Ux LUA_CPATH "./?.so;$HOME/lua5.1/lib/lua/5.1/?.so;$HOME/lua5.1/lib/lua/5.1/loadall.so;$HOME/.luarocks/lib/lua/5.1/?.so"

set -Ux fish_user_paths (rbenv root)/shims $fish_user_paths
