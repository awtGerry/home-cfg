_:
{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.programs.rofi;
  # TODO: Hacer el tema claro
  launcher_config =
    if config.theme.variant == "dark" then "./config/dark.rasi" else "./config/light.rasi";
  rofi = pkgs.rofi-wayland;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      rofi
      rofi-emoji
    ];
    programs.rofi = {
      package = rofi;

      font = "SF-Pro Display 10";
      terminal = config.apps.terminal;
      location = "center";

      theme = launcher_config;
    };
  };
}
