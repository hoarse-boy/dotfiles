{ pkgs, ... }:

{
  home.packages = with pkgs; [
    thunar
    thunar-archive-plugin
    thunar-media-tags-plugin
    thunar-volman
    gvfs
    glib  # needed for gio (trash backend)
  ];

  # gvfs needs to run as a user service
  # services.gvfs.enable = true; # FIX: . check and test this. remove comments later:
}
