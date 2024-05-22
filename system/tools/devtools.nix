{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # (rust-bin.stable.latest.default.override {
    #   targets = ["x86_64-unknown-linux-gnu" "wasm32-unknown-unknown"];
    #   extensions = ["rust-analyzer" "rust-src" "rust-std"];
    # })

    git
    ninja
    sqlite
    python3

    rust-bindgen
    # rust-analyzer
    # rustc
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

    # java
    openjdk
    maven

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

    bash-completion
  ];
}
