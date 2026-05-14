{ pkgs, ... }:

{
  services.greetd = {
    enable = true;

    settings = {
      terminal.vt = 2;

      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --greeting 'AUTHORIZED PERSONNEL ONLY' --remember --remember-user-session --cmd Hyprland";
        # command = "tuigreet --time --asterisks --greeting 'AUTHORIZED PERSONNEL ONLY' --remember --remember-user-session --cmd Hyprland";
        # command = "tuigreet --time --asterisks --greeting 'AUTHORIZED PERSONNEL ONLY' --remember --remember-user-session --cmd start-hyprland";
        user = "greeter";
      };
    };
  };

  services.xserver.displayManager.sddm.enable = false;

  # to fix anoying gnome apps asking for password after login
  security.pam.services.greetd = {
    text = ''
      auth       required     pam_securetty.so
      auth       requisite    pam_nologin.so
      auth       include      system-local-login
      auth       optional     pam_gnome_keyring.so
      account    include      system-local-login
      session    include      system-local-login
      session    optional     pam_gnome_keyring.so auto_start
    '';
  };
}
