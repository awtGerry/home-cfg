{ self, ... }:
{
  pkgs,
  lib,
  config,
  ...
}:

let
  # TODO: Hacer el tema claro
  launcher_config =
    if config.theme.variant == "dark" then "./config/dark.rasi" else "./config/light.rasi";
  rofi = pkgs.rofi-wayland;
in
{
  home.packages = with pkgs; [ rofi-emoji ];

  programs.rofi = {
    enable = true;
    package = rofi;

    font = "SF-Pro 10";
    terminal = config.apps.terminal;
    location = "center";

    theme = launcher_config;
  };
}
