{ config, pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      package = pkgs.qemu_full;
      ovmf.enable = true;
      swtpm.enable = true;

      verbatimConfig = ''
        namespaces = []
      '';
    };
  };

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    virt-viewer
    spice
    spice-gtk
    spice-vdagent
    virglrenderer
    dnsmasq
    bridge-utils
    vde2
    mesa
    mesa-demos
  ];

  users.users.jho.extraGroups = [
    "libvirtd"
    "kvm"
  ];

  networking.firewall.trustedInterfaces = [ "virbr0" ];

  boot.kernelModules = [
    "kvm-amd"
    "kvm-intel"
  ];

  virtualisation.spiceUSBRedirection.enable = true;

  services.spice-vdagentd.enable = true;
}
