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
            # set -Ux fish_user_paths (rbenv root)/shims $fish_user_paths

            abbr wk 'cd ~/sync-work'
            abbr sl slumber -f ~/sync-work/slumber-http/slumber.yml

        case Linux
            # Set critical system paths FIRST
            set -gx PATH /usr/bin /usr/local/bin /usr/local/sbin

            set -a PATH $HOME/.local/bin $HOME/lua5.1/bin $HOME/bin \
                /usr/lib/jvm/default/bin $HOME/.local/share/flatpak/exports/bin \
                /usr/lib/rustup/bin

            test -f ~/.config/fish/arch.fish; and source ~/.config/fish/arch.fish # for file that cannot be push to git

            # set -gx editor "neovide --fork --wayland_app_id neovide"

            # abbr nv 'neovide --fork --wayland_app_id neovide'
            abbr pwd 'pwd && pwd | wl-copy'

            # open file manager in current directory
            abbr dol 'nohup dolphin . > /dev/null 2>&1 &'
            abbr open 'setsid thunar .'

            abbr wk 'cd ~/work/sync-work'

            # yay package manager
            abbr y yay
            # abbr ys 'yay -S --noconfirm'
            abbr ys 'yay -S'
            abbr yS 'yay -Ss'
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

            # other commands
            alias rm trash-put
            # alias grep rg
            # alias find fd

            # npm
            set -gx PATH $HOME/.npm-global/bin $PATH
            alias cz czg

            # set your download directories
            set -Ux YT_VIDEO_DIR ~/syncthing-temp-folder/temp-videos
            set -Ux YT_MUSIC_DIR ~/Music/sync-music

            # youtube video downloads (variable paths)
            abbr yt "yt-dlp -P $YT_VIDEO_DIR"
            abbr ytsd "yt-dlp -P $YT_VIDEO_DIR -f 'bestvideo[height<=480][fps<=30]+bestaudio/best[height<=480][fps<=30]'"
            abbr ythd "yt-dlp -P $YT_VIDEO_DIR -f 'bestvideo[height<=720]+bestaudio/best[height<=720]'"
            abbr ytfhd "yt-dlp -P $YT_VIDEO_DIR -f 'bestvideo[height<=1080][fps<=60]+bestaudio/best[height<=1080][fps<=60]'"

            # youtube audio (mp3) downloads. this will embed metadata for mpd cli or any other mp3 player.
            # use auto-fix-mp3-tags to fix the tags of all mp3 files in the directory.
            abbr ytmp3 "yt-dlp -x --audio-format mp3  --embed-metadata  --embed-thumbnail  -o '%(title)s.%(ext)s' -P $YT_MUSIC_DIR"
            abbr ytopus "yt-dlp -f bestaudio -x --audio-format opus --embed-metadata --embed-thumbnail -o '%(title)s.%(ext)s' -P $YT_MUSIC_DIR"

            # outline-cli https://github.com/Kira-NT/outline-cli. need outline vpn added to work see the docs.
            abbr cvpn "sudo -E vpn connect oktagon"
            abbr dvpn "sudo -E vpn disconnect"
            abbr svpn "sudo -E vpn status"

            abbr sl slumber -f ~/work/sync-work/slumber-http/slumber.yml

            source $HOME/.cargo/env.fish

            # set -gx PATH $HOME/.local/zig/0.16.0-dev $PATH
            set -gx PATH $HOME/.local/zig/current $PATH

            set -U fish_user_paths $fish_user_paths $HOME/go/bin

            mise activate fish | source

            # atch commands
            alias atch "env SHELL=(which fish) atch"
            abbr a atch

            # kill
            abbr ak "atch -k"
            abbr al "atch -l"

            # current session
            abbr ai "atch -i"
            abbr ae "atch -e '^B'"

            # FIX: . check and test this. remove comments later:
            set -Ux PAGER "bat --paging=always --style=plain"
    end
end
