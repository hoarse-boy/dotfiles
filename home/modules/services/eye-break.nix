{
  home.file.".local/bin/eye-break.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      idle=$(loginctl show-session "$XDG_SESSION_ID" -p IdleHint --value 2>/dev/null || echo no)

      if [[ "$idle" == "yes" ]]; then
        exit 0
      fi

      # if command -v swayosd-client >/dev/null 2>&1; then
      #   swayosd-client --custom-message "👀 Eye Break — 20 seconds"
      # else
        notify-send "👀 Eye Break" "Look away for 20 seconds" -t 5000
      # fi
    '';
  };

  systemd.user.services."eye-break" = {
    Unit = {
      Description = "Eye Break Reminder";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "/home/jho/.local/bin/eye-break.sh";
    };
  };

  systemd.user.timers."eye-break" = {
    Unit = {
      Description = "Eye Break Timer";
    };
    Timer = {
      OnBootSec = "5m";
      OnUnitActiveSec = "2h";
      Unit = "eye-break.service";
    };
    Install = {
      WantedBy = ["timers.target"];
    };
  };
}
