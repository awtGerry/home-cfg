{ pkgs, config, ... }:

let
  geth = pkgs.writeShellScriptBin "geth" ''
    #!/usr/bin/env bash
    nix hash to-sri --type sha256 $(nix-prefetch-url "$1")
  '';
in
{
  home.packages = [ geth ];
}
