{ config, ... }:

{
  home.file.".local/bin/generate-vivaldi-pwa" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/scripts/generate-vivaldi-pwa";
  };

  # home.file.".local/bin/github-setup".source =
  #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/scripts/setup-github";
}
