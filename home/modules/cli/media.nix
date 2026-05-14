{ config, ... }:

{
  home.file.".local/bin/auto-fix-mp3-tags" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/scripts/auto-fix-mp3-tags";
  };

  home.file.".local/bin/sort-wallpaper" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/scripts/sort-wallpaper";
  };

  home.file.".local/bin/screenshot-avif" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/scripts/screenshot-avif";
  };

  home.file.".local/bin/convert-image-to-avif" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/scripts/convert-image-to-avif";
  };

  home.file.".local/bin/upscayl-image" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/scripts/upscayl-image";
  };

}
