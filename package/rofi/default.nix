{ lib, pkgs, config, ... }:

{
  programs.rofi = {
    enable = true;

    font = "Noto Sans 10";
    terminal = "kitty";
    location = "center";

    configPath = "./config/config.rasi";
  };
}
