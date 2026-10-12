_:
{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.programs.rofi;
  rofi = pkgs.rofi;
  # inherit (config.lib.formats.rasi) mkLiteral;

  # launcher_config =
  #   if config.theme.variant == "dark" then "./config/dark.rasi" else "./config/light.rasi";
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      rofi
      rofi-emoji
    ];
    programs.rofi = {
      package = rofi;

      # location es un entero: 1 = top-left.
      settings = {
        font = "SF-Pro Display 10";
        terminal = config.apps.terminal;
        location = 1;
      };

      # theme = launcher_config;
    };
  };
}
