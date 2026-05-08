{
  home.file.".local/bin/standup-reminder" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      idle=$(loginctl show-session "$XDG_SESSION_ID" -p IdleHint --value 2>/dev/null || echo no)

      if [[ "$idle" == "yes" ]]; then
        exit 0
      fi

      # if command -v swayosd-client >/dev/null 2>&1; then
      #   swayosd-client --custom-message "🧍 Stand Up & Stretch"
      # else
        notify-send "🧍 Stand Up" "Time to stretch and move" -t 5000
      # fi
    '';
  };

  systemd.user.services."standup-reminder" = {
    Unit = {
      Description = "Stand Up Reminder";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "/home/jho/.local/bin/standup-reminder";
    };
  };

  systemd.user.timers."standup-reminder" = {
    Unit = {
      Description = "Stand Up Reminder Timer";
    };
    Timer = {
      OnBootSec = "10m";
      OnUnitActiveSec = "30m";
      Unit = "standup-reminder.service";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
