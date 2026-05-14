{ pkgs, ... }:

{
  programs.delta = {
    enable = true;
    options = {
      features = "side-by-side";
      line-numbers = true;
      syntax-theme = "Monokai Extended";
      diff-highlight = true;
    };
    enableGitIntegration = true;
  };

  programs.git = {
    enable = true;

    settings = {
      user.name = "hoarse-boy";
      user.email = "jourdymagoofficial@gmail.com";
      merge = {
        conflictstyle = "diff3";
        tool = "delta";
      };

      init.defaultBranch = "main";

      credential.helper = "store";

      pull.rebase = true;

      core = {
        pager = "delta --dark --paging=never";
        fileMode = true;
        excludesfile = "~/.gitignore_global";
      };

      # interactive.diffFilter = "delta --color-only"; # FIX: . check and test this. remove comments later: # FIX: . conflicting with programs.delta.nix?

      "delta \"diff\"" = {
        syntax-highlighting = true;
      };

      "delta \"side-by-side\"" = {
      };
    };

    ignores = [ "~/.gitignore_global" ];
  };

  home.file.".gitignore_global".text = ''
    # tmux
    .tmux/plugins/*
    .config/tmux/plugins/*

    .config/fish/fish_variables
    .config/fish/conf.d/*

    # Logs
    logs
    *.log
    npm-debug.log*
    yarn-debug.log*
    yarn-error.log*
    firebase-debug.log*
    firebase-debug.*.log*

    # Firebase cache
    .firebase/

    # Runtime data
    pids
    *.pid
    *.seed
    *.pid.lock

    # js coverage
    lib-cov

    # Coverage
    coverage
    .nyc_output

    # Grunt
    .grunt

    # Bower
    bower_components

    # node-waf
    .lock-wscript

    # Compiled addons
    build/Release

    # Dependencies
    node_modules/

    # npm
    .npm

    # eslint
    .eslintcache

    # REPL
    .node_repl_history

    # npm pack
    *.tgz

    # Yarn
    .yarn-integrity

    # env
    .env
    .envrc

    # restic
    .config/restic/pass
    .cache/restic

    # rclone
    .config/rclone/rclone.conf
  '';

  home.packages = with pkgs; [
    git
    delta
  ];
}

# DEL: . DELETE LINES LATER
# warning: Git tree '/home/jho/my-dotfiles' is dirty
# trace: warning: The option `programs.git.userEmail' defined in `/nix/store/dg2zyqil4mv19mvav8sckyil82yinczc-source/home/modules/system/gitconfig.nix' has been renamed to `programs.git.settings.user.email'.
# trace: warning: The option `programs.git.userName' defined in `/nix/store/dg2zyqil4mv19mvav8sckyil82yinczc-source/home/modules/system/gitconfig.nix' has been renamed to `programs.git.settings.user.name'.
# trace: warning: The option `programs.git.extraConfig' defined in `/nix/store/dg2zyqil4mv19mvav8sckyil82yinczc-source/home/modules/system/gitconfig.nix' has been renamed to `programs.git.settings'.
# trace: warning: The option `programs.git.delta.options' defined in `/nix/store/dg2zyqil4mv19mvav8sckyil82yinczc-source/home/modules/system/gitconfig.nix' has been renamed to `programs.delta.options'.
# trace: warning: The option `programs.git.delta.enable' defined in `/nix/store/dg2zyqil4mv19mvav8sckyil82yinczc-source/home/modules/system/gitconfig.nix' has been renamed to `programs.delta.enable'.
# error:
