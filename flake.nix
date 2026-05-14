{
  description = "jho's nixos";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;

        # overlays = [
        #   (import ./overlays/pnpm.nix)

        config.allowUnfreePredicate =
          pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            "postman"
            "vivaldi"
            "slack"
            "ventoy"
          ];
      };
    in
    {
      # for arch / standalone home-manager
      # home-manager switch --flake ~/dotfiles#jho
      homeConfigurations."jho" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home ];
      };

      # nixos full system
      # sudo nixos-rebuild switch --flake ~/dotfiles#jho
      nixosConfigurations.jho = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./nixos/configuration.nix

          home-manager.nixosModules.home-manager

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.jho = import ./home;
              backupFileExtension = "backup";
            };
          }
        ];
      };
    };
}
