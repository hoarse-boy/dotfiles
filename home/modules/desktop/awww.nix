{ pkgs, ... }:

# does need this. just use overlays/awww.nix # FIX: . check and test this. remove comments later:
{
  nixpkgs.overlays = [
    (final: prev: {
      awww = pkgs.rustPlatform.buildRustPackage {
        pname = "awww";
        version = "git";

        src = pkgs.fetchFromGitHub {
          owner = "LGFae";
          repo = "awww";
          rev = "main";
          hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        };

        cargoLock.lockFile = ./Cargo.lock; # or use cargoHash

        buildInputs = [ pkgs.dav1d ];

        cargoBuildFlags = [
          "--package"
          "client"
          "--features"
          "avif"
        ];
      };
    })
  ];
}
