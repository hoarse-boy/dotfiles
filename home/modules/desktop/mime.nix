{ ... }:

{
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "image/png" = [ "imv.desktop" ];
      "image/jpeg" = [ "imv.desktop" ];
      "image/jpg" = [ "imv.desktop" ];
      "image/gif" = [ "imv.desktop" ];
      "image/webp" = [ "imv.desktop" ];
      "image/bmp" = [ "imv.desktop" ];
      "image/tiff" = [ "imv.desktop" ];
      "image/x-portable-pixmap" = [ "imv.desktop" ];
      "image/x-portable-bitmap" = [ "imv.desktop" ];
      "image/x-portable-graymap" = [ "imv.desktop" ];
      "image/avif" = [ "imv.desktop" ];
      "image/heic" = [ "imv.desktop" ];
      "image/heif" = [ "imv.desktop" ];
      "image/svg+xml" = [ "imv.desktop" ];
    };
  };
}
