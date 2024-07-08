{ lib, pkgs, config, ... }:

let
  home = config.home.homeDirectory;
in
{
  imports = [
    ../../system/env.nix
  ];

  xdg.userDirs = {
    enable = true;
    createDirectories = true; # Create directories if they don't exist

    desktop = "${home}/Desktop";
    documents = "${home}/Documents";
    download = "${home}/Downloads";
    music = "${home}/Music";
    pictures = "${home}/Pictures";
    videos = "${home}/Videos";
    publicShare = "${home}/Public";

    templates = null; # never use templates dir so i don't need it

    extraConfig = {
      XDG_DEV_DIR = "${home}/Dev";
      XDG_GAMES_DIR = "${config.home.driveDirectory}/Games";
    };
  };
}
