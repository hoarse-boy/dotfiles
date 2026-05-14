{
  systemd.user.services.random-wallpaper = {
    Unit.Description = "Change wallpaper randomly";

    Service = {
      Type = "oneshot";
      ExecStart = "%h/.config/hypr/scripts/random-wallpaper.sh";
    };
  };

  systemd.user.timers.random-wallpaper = {
    Unit.Description = "Run random wallpaper every 3 minutes";

    Timer = {
      OnBootSec = "2min";
      OnUnitActiveSec = "3min";
      AccuracySec = "30s";
    };

    Install.WantedBy = [ "timers.target" ];
  };
}
