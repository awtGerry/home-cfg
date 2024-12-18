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

      userName = "Victor Rodriguez";
      userEmail = "awtGerry@gmail.com";

      extraConfig = {
        init.defaultBranch = "master";
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
      lazygit
      ripgrep
      ninja
      sqlite
      python3

      # rust-bindgen
      # rustc
      # cargo
      openssl
      pkg-config

      gcc
      glib
      glibc
      go
      gleam
      erlang
      perl

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
