{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    cargo
    rustc
    rustup
	  clang
	  gcc
	  git
    go
    neovim
	  ninja
	  nodejs
    nodePackages.pnpm
    glib
    sqlite
	  openssl
    pkg-config
    perl
    gtk3

    lua-language-server
    rust-analyzer
    gopls
    clang-tools
    # nodePackages.typescript
    nodePackages.typescript-language-server

    # term stuff
    jq
	  ripgrep
	  xclip
  ];
}
