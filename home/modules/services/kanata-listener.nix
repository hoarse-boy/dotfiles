{ pkgs, config, ... }:

{
  home.packages = [ pkgs.netcat-openbsd ];

  systemd.user.services.kanata-waybar-listener = {
    Unit = {
      Description = "kanata listener";
      After = "kanata.service";
    };

    Service = {
      ExecStart = "${config.home.homeDirectory}/.config/waybar/scripts/kanata-listener.sh";
      Type = "simple";
      Restart = "always";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
