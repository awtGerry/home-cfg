{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    git
    ninja
    sqlite

    # rust-analyzer
    rustc
    cargo
    openssl
    pkg-config

    gcc
    glib
    glibc
    go
    perl

    nodejs
    nodePackages.pnpm

    # Language servers
    lua-language-server
    rust-analyzer
    gopls
    clang-tools
    tailwindcss-language-server
    # nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.bash-language-server
    nodePackages.svelte-language-server
  ];
}
