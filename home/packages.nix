{ pkgs, ... }:

{
  home.username = "jho";
  home.homeDirectory = "/home/jho";
  home.stateVersion = "24.11";

  # NO programs.* or files.* — just packages
  home.packages = with pkgs; [
    # gui apps
    dbeaver-bin
    postman
    gimp
    telegram-desktop
    # vivaldi # FIX: . enable it back
    firefox
    # slack
    onlyoffice-desktopeditors
    imv
    obs-studio
    upscayl

    # cli tools
    coreutils
    lsd
    starship
    zoxide
    bat
    jq
    fx
    trash-cli
    fd
    ripgrep
    wev
    atuin
    tokei
    dust
    lsof
    gum
    cmatrix
    tree
    strace
    openrgb
    upscayl-ncnn
    unar

    # core utils
    # ffmpeg
    # ffmpeg-full

    # wayland / display
    grim
    slurp
    wl-clipboard
    hyprpaper
    awww # FIX: . chnage to use with avif feature.

    # media / graphics
    yt-dlp
    id3v2
    # python3Packages.mutagen # DEL: . DELETE LINES LATER
    mailcap

    # dev tooling
    neovim
    # lazygit # DEL: . DELETE LINES LATER
    # delta # DEL: . DELETE LINES LATER
    tmux
    fish
    rustup
    go
    golangci-lint
    deno
    nodejs
    zig
    cmake
    ninja
    meson
    dprint
    mise

    # python packages
    (python3.withPackages (
      ps: with ps; [
        opencv4
        mutagen
      ]
    ))

    # databases / infra
    postgresql
    valkey

    # containers / virt
    podman
    podman-compose
    crun
    fuse-overlayfs
    slirp4netns
    qemu
    libvirt
    virt-manager
    virt-viewer
    dnsmasq
    vde2
    bridge-utils
    OVMF # edk2-ovmf
    spice
    spice-gtk
    spice-vdagent
    virglrenderer
    mesa
    mesa-demos # mesa-utils

    # screen / recording
    gpu-screen-recorder

    # syncing
    syncthing

    # misc
    # ventoy
    # gnome-disk-utility
    swayosd
    cliphist
    t-rec
    limine
    wl-kbptr

    # libs (if needed standalone)
    webkitgtk_4_1
    gdk-pixbuf
  ];
}
