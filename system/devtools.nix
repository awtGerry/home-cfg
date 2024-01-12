{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # cargo
    # rustc
    # rustup
    # clang
    gcc
    git
    go
    ninja
    glib
    sqlite
    openssl
    pkg-config
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
