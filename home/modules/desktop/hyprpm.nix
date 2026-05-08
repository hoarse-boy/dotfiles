{ lib, ... }:

let
  plugins = [ "hyprscrolling" ];
  repo = "https://github.com/hyprwm/hyprland-plugins";
in
{
  home.activation.hyprpm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if command -v hyprpm >/dev/null; then
      hyprpm update || true

      if ! hyprpm list | grep -q "Repository hyprland-plugins"; then
        hyprpm add ${repo}
      fi

      ${builtins.concatStringsSep "\n" (map (p: ''
        if ! hyprpm list | grep -A1 "Plugin ${p}" | grep -q "enabled: true"; then
          hyprpm enable ${p}
        fi
      '') plugins)}

      hyprctl reload || true
    fi
  '';
}
