# { pkgs, ... }:

# {
#   # home.packages = [ pkgs.kitty ]; # FIX: . enable it in nixos

#   xdg.configFile."kitty/arch.conf".text = ''
#     font_family      JetBrainsMono Nerd Font
#     font_size        12.0

#     background_opacity 1.0

#     shell ${pkgs.fish}/bin/fish
#   '';
# } # DEL: . DELETE LINES LATER

{} # DEL: . DELETE LINES LATER
