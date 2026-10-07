_:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.profiles.development;
in
{
  options.profiles.development = {
    enable = lib.mkEnableOption "Habilita configuraciones y programas para desarrolladores";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;

      settings = {
        user.name = "Victor Rodriguez";
        user.email = "awtGerry@gmail.com";
        init.defaultBranch = "main";
        pull.rebase = "merges";
        rebase.autostash = true;
        diff.algorithm = "histogram";
      };

      ignores = [
        ".test"
        ".env"
        ".envrc"
        ".direnv"
        "result"
      ];
    };

    nixpkgs.allowedUnfree = [
      # "claude-code"
      "appflowy"
    ];

    home.packages = with pkgs; [

      appflowy

      chromium # I just don't get use to work with the same browser for research and development, so idk

      ripgrep
      ninja
      sqlite
      python3
      docker-compose
      tree
      sqlx-cli
      openssl
      pkg-config
      xh
      jq
      mold

      # Testing AI tools
      # claude-code
      # codex

      # Paginas de manual
      ascii
      man-pages
      man-pages-posix
      glibcInfo

      # Compiladores y lenguajes
      gcc
      glib
      glibc
      go
      gleam
      erlang
      perl
      lua

      nodejs
      pnpm

      # java
      # openjdk8
      openjdk21
      maven

      # Language servers
      lua-language-server
      rust-analyzer
      gopls
      clang-tools
      tailwindcss-language-server
      typescript-language-server
      bash-language-server
      svelte-language-server
      bash-completion
    ];
  };
}
