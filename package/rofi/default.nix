{ lib, pkgs, config, ... }:

{
  home.packages = with pkgs; [
    rofi-emoji
  ];

  programs.rofi = {
    enable = true;

    font = "Noto Sans 10";
    terminal = "kitty";
    location = "center";

    theme = "/home/gerry/Dev/public/home-cfg/package/rofi/config/config.rasi";
  };
}
