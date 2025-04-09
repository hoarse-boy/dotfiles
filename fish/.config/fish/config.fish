# Set critical system paths FIRST
set -gx PATH /usr/bin /usr/local/bin /usr/local/sbin

# Load basic utilities before anything else
if command -q uname
    load_os_cmds
else
    echo "Warning: uname not available yet" >&2
end

# Now set user paths (without duplicates)
set -a PATH $HOME/.local/bin $HOME/lua5.1/bin $HOME/bin \
    /usr/lib/jvm/default/bin /home/jho/.local/share/flatpak/exports/bin \
    /usr/lib/rustup/bin

# Ensure PATH is clean
dedupe_path

# Initialize tools only if available
if command -q starship
    starship init fish | source
end

if command -q zoxide
    zoxide init fish | source
end

# Ensure fish_user_paths is unique
ensure_unique_path

# Universal paths (only if commands exist)
if command -q npm
    set -Ua fish_user_paths (npm config get prefix)/bin
end

set -Ua fish_user_paths $HOME/.local/bin

# Set fish greeting
set -g fish_greeting

# makes the cursor change shape when in vim insert mode and normal mode
set -g fish_vi_force_cursor 1
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore

# Directory listing
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
abbr diff 'delta --pager=never'

# nvim
abbr v nvim
abbr lazy "cd ~/.local/share/nvim/lazy/LazyVim/ && $editor"

# ghostty
abbr ssh 'TERM=xterm-256color ssh ' # need the env TERM for ghostty to work as the delete button is not working.

# kitty
abbr kt 'kitten ssh'

# wezterm 
abbr ws 'wezterm connect unix & disown & exit' # re-attached or create new wezterm session if not exist.

# tmux 
abbr t tmux
abbr ta 'tmux attach-session -t'
abbr tn 'tmux new-session -s'

# most used commands
abbr lg lazygit
abbr kb kubectl
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

# Always mkdir a path
abbr mkdir 'mkdir -p'

# others
abbr e exit
abbr c clear
abbr vc 'code .'
abbr sudo 'sudo -E'
abbr ch 'chmod +x'
abbr dot 'cd ~/my-dotfiles'
abbr con 'cd ~/.config'

# modify vim mode binding
set fish_key_bindings fish_user_key_bindings

set -Ux EDITOR nvim # used for crontab -e

# opam configuration
source /home/jho/.opam/opam-init/init.fish >/dev/null 2>/dev/null; or true
