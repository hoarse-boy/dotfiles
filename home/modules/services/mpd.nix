{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    mpd
    mpd-mpris
    mpc
    rmpc
  ];

  systemd.user.services.mpd = {
    Unit = {
      Description = "Music Player Daemon";
      After = [
        "network.target"
        "sound.target"
      ];
      Conflicts = [ "mpd.service" ];
    };
    Service = {
      Type = "notify";
      ExecStart = "${pkgs.mpd}/bin/mpd --systemd ${config.xdg.configHome}/mpd/mpd.conf";
      LimitRTPRIO = 40;
      LimitRTTIME = "infinity";
      LimitMEMLOCK = "64M";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
