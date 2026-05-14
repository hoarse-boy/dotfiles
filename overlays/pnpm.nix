final: prev: {
  buildPnpmPackage = prev.callPackage
    "${prev.path}/pkgs/build-support/node/build-pnpm-package.nix" {};
}
