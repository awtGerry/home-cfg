{ lib, pkgs, config, ... }:

let
  cfg = config.xdg.userDirs;
in
{
  programs.xdg.userDirs = {
    enable = true;
  };
}
