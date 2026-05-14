# { config, username, ... }:

{
  imports = [
    ./packages.nix
    ./config.nix

    # modules
    ./modules/cli
    ./modules/desktop
    ./modules/services
    ./modules/system
  ];

  # home.username = username;
  home.username = "jho";
  home.homeDirectory = "/home/jho";
  home.stateVersion = "24.11";

  systemd.user.startServices = "sd-switch";

  # # Ensure bin directory exists
  #  home.file.".local/bin" = {
  #    source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.local/bin";
  #    recursive = true;
  #  };

  programs = {
    home-manager.enable = true;
    nix-search-tv.enableTelevisionIntegration = true; # FIX: . check and test this. remove comments later:
  };
}
