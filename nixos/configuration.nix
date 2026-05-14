# { # DEL: . DELETE LINES LATER
#   description = "Hyprland on Nixos";

#   imports = [
#     ./hardware-configuration.nix
#     ./modules/kanata-system.nix
#     ./modules/greetd.nix
#   ];

#   nix.settings.experimental-features = [
#     "nix-command"
#     "flakes"
#   ];

#   inputs = {
#     nixpkgs.url = "nixpkgs/nixos-unstable";
#     home-manager = {
#       url = "github:nix-community/home-manager";
#       inputs.nixpkgs.follows = "nixpkgs";
#     };
#   };

#   outputs =
#     { nixpkgs, home-manager, ... }:
#     {
#       nixosConfigurations.hyprland-btw = nixpkgs.lib.nixosSystem {
#         system = "x86_64-1linux";
#         modules = [
#           ./configuration.nix
#           home-manager.nixosModules.home-manager
#           {
#             home-manager = {
#               useGlobalPkgs = true;
#               useUserPackages = true;
#               users.jho = import ./home.nix;
#               backupFileExtension = "backup";
#             };
#           }
#         ];
#       };
#     };
# }

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
