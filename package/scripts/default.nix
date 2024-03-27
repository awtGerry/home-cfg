{ config, pkgs, ... }:

{
  imports = [
    ./screenshot.nix
    ./tmux-fzf.nix
  ];
}
