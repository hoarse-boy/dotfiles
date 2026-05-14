{ config, pkgs, ... }:

{
  programs.hyprland.enable = true;
  # programs.zsh.enable = true;
  programs.thunar.enable = true; # FIX: . dobule?
  programs.nix-ld.enable = true;

  # services.displayManager.sddm.enable = true; # DEL: . DELETE LINES LATER
  services.xserver.enable = true;

  networking.networkmanager.enable = true; # FIX: . check for double in other config files

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  # FIX: . check and test this. remove comments later:
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  services.openssh.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
    noto-fonts-cjk-sans
    twemoji-color-font
  ];

  # FIX: . check and test this. remove comments later:
  # check with other packages.nix
  # remove from the other packages as this is more for hyprland?
  environment.systemPackages = with pkgs; [
    # cli
    git
    curl
    wget
    unzip
    p7zip
    ripgrep
    fd
    jq
    fzf
    eza
    bat
    tree-sitter
    neovim
    tmux
    lazygit
    fastfetch
    starship
    quickshell

    # dev
    nodejs
    lua
    luarocks
    python3

    # hyprland
    hyprland
    hyprlock
    hypridle
    waybar
    rofi # FIX: .
    rofi-emoji
    wlogout
    swaynotificationcenter
    swayosd
    wl-clipboard
    grim
    slurp
    swappy
    wf-recorder
    hyprpicker
    satty

    # file manager
    yazi
    thunar
    file-roller

    # media
    mpv
    cava
    playerctl
    brightnessctl
    loupe
    feh
    imagemagick

    # qt/gtk
    qt6.qtwayland
    qt5.qtwayland
    libsForQt5.qt5ct
    qt6ct
    nwg-look
    nwg-displays
    gtk3
    gtk4

    # FIX: . check and test this. remove comments later:
    adw-gtk3

    # FIX: . check and test this. remove comments later:
    # has this in other file
    # audio

    # misc
    polkit_gnome
    libnotify
    networkmanagerapplet
    tesseract
    tesseract4
  ];
}
