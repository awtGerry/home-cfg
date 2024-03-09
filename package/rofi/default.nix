{ lib, pkgs, config, ... }:

let
  rose-pine = "~/Dev/public/home-cfg/package/rofi/config/config.rasi";
in
{
  home.packages = with pkgs; [
    rofi-emoji
  ];

  programs.rofi = {
    enable = true;

    font = "Noto Sans 10";
    terminal = "kitty";
    location = "center";

    theme = rose-pine;
  };
}
