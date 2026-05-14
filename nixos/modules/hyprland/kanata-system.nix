{ ... }:

{
  users.groups.uinput = {};

  users.users.jho.extraGroups = [ "input" "uinput" ];

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  boot.kernelModules = [ "uinput" ];
}
