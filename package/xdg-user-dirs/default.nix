{ lib, pkgs, config, ... }:

let
  home = config.home.homeDirectory;
in
{
  programs.xdg.userDirs = {
    enable = true;
    createDirectories = true; # Create directories if they don't exist

    desktop = "${home}/Desktop";
    documents = "${home}/Documents";
    downloads = "${home}/Downloads";
    music = "${home}/Music";
    pictures = "${home}/Pictures";
    public = "${home}/Public";
    templates = "${home}/Templates";
    videos = "${home}/Videos";
  };
}
