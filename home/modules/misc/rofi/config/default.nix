_:
{
  config,
  pkgs,
  lib,
  ...
}:

# Configuracion para rofi
let
  cfg = config.programs.rofi;
  # mode = config.theme.variant;
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  config = lib.mkIf cfg.enable {
    # TODO: Manera de implimentar esto con colores?
    programs.rofi.theme = {
      "*" = {
        background-color = mkLiteral "#282828";
        foreground-color = mkLiteral "#fbf1c7";
      };
      "prompt" = {
        enabled = mkLiteral "true";
        text = mkLiteral "Search";
        text-color = mkLiteral "fbf1c7"; # TODO: Necesario?
      };
    };
  };
}
