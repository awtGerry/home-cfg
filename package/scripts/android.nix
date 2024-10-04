{ pkgs, ... }:

let
  # geth = pkgs.writeShellScriptBin "geth" ''
  #   #!/usr/bin/env bash
  #   nix hash to-sri --type sha256 $(nix-prefetch-url "$1")
  # '';
  start-android = pkgs.writeShellScriptBin "android" ''
    sudo systemctl start waydroid-container
    waydroid session start
    waydroid show-full-ui
  '';
in
{
  home.packages = [ start-android ];
}
