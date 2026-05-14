# { pkgs, ... }:

# let
#   czg = pkgs.writeShellScriptBin "czg" ''
#     export npm_config_cache="$HOME/.cache/npm"
#     exec ${pkgs.nodejs}/bin/npx --yes czg@1.13.0 "$@"
#   '';
# in
# {
#   home.packages = [
#     czg
#     pkgs.delta
#   ];

#   programs.lazygit = {
#     enable = true;
#     settings = {
#       git.pagers = [
#         {
#           colorArg = "always";
#           pager = "delta --dark --paging=never";
#         }
#       ];
#       customCommands = [
#         {
#           key = "C";
#           command = "clear && czg";
#           description = "commit with czg";
#           context = "files";
#           loadingText = "opening czg";
#           output = "terminal";
#         }
#       ];
#     };
#   };
# } # DEL: . DELETE LINES LATER

{ pkgs, ... }:

{
 # czg will be installed from npm global
  home.packages = [
    pkgs.nodejs
    pkgs.delta
  ];

  programs.lazygit = {
    enable = true;
    settings = {
      git.pagers = [
        {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        }
      ];

      customCommands = [
        {
          key = "C";
          command = "clear && czg";
          description = "commit with czg";
          context = "files";
          loadingText = "opening czg";
          output = "terminal";
        }
      ];
    };
  };
}
