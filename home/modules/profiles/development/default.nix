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

    home.packages = with pkgs; [
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
      nodePackages.pnpm

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
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      nodePackages.svelte-language-server
      bash-completion
    ];
  };
}
