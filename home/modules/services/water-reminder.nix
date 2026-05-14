{
  home.file.".local/bin/water-reminder" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      notify() {
        # if command -v swayosd-client >/dev/null 2>&1; then
        #   swayosd-client --custom-message "💧 Drink Water"
        # else
            notify-send "💧 Drink Water" "Hydration reminder" -t 5000
        # fi
      }

      notify
    '';
  };

  systemd.user.services."water-reminder" = {
    Unit = {
      Description = "Water Reminder";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "/home/jho/.local/bin/water-reminder";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.timers."water-reminder" = {
    Unit = {
      Description = "Water Reminder Timer";
    };
    Timer = {
      OnBootSec = "15m";
      OnUnitActiveSec = "45m";
      Unit = "water-reminder.service";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
