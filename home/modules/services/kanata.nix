{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kanata-with-cmd
  ];

  systemd.user.services.kanata = {
    Unit = {
      Description = "Kanata keyboard remapper";
    };

    Service = {
      # must run the command `-p 7070` for kanata-listener.sh to work
      ExecStart = "${pkgs.kanata-with-cmd}/bin/kanata -c %h/.config/kanata/config.kbd -p 7070 --nodelay";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
