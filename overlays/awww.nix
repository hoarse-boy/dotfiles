final: prev: {
  awww = prev.awww.overrideAttrs (old: {
    buildInputs = (old.buildInputs or []) ++ [ prev.dav1d ];

    cargoBuildFlags = [
      "--package" "client"
      "--features" "avif"
    ];
  });
}
