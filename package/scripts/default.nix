{ config, pkgs, ... }:

{
  imports = [
    ./screenshot.nix
    ./tmux-fzf.nix
    ./wp.nix
    ./hash.nix
  ];
}
