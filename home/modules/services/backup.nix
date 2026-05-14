{ config, ... }:

{
  # rclone
  home.file.".local/bin/rclone-media-backup" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/scripts/rclone-media-backup";
  };

  systemd.user.services.rclone-media-backup = {
    Unit = {
      Description = "Rclone Media Backup (MEGA)";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "%h/.local/bin/rclone-media-backup";
    };
  };

  systemd.user.timers.rclone-media-backup = {
    Unit = {
      Description = "Run rclone media backup daily";
    };

    Timer = {
      OnCalendar = "12:00";
      Persistent = true;
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  # restic
  home.file.".local/bin/restic-backup" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/scripts/restic-backup";
  };

  systemd.user.services.restic-backup = {
    Unit = {
      Description = "Restic Backup";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "%h/.local/bin/restic-backup";
    };
  };

  systemd.user.timers.restic-backup = {
    Unit = {
      Description = "Run restic backup daily";
    };

    Timer = {
      OnCalendar = "12:00";
      Persistent = true;
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
