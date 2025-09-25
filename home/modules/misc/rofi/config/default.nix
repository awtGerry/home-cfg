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
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  config = lib.mkIf cfg.enable {
    # TODO: Implementar esto con colores?
    programs.rofi.theme = {
      "*" = {
        background-color = mkLiteral "transparent";
        foreground-color = mkLiteral "#62707A";
      };

      "configuration" = {
        font = mkLiteral "\"SF Pro Display 14\"";
      };

      "prompt" = {
        enabled = mkLiteral "true";
        font = mkLiteral "\"Font Awesome 6 Free Solid 12\"";
        text = mkLiteral "\"\"";
        background-color = mkLiteral "transparent";
        foreground-color = mkLiteral "#62707A";
      };

      "window" = {
        width = mkLiteral "450px"; # Set width to 350 pixels
        padding = mkLiteral "0.5em";
        margin = mkLiteral "12px 0 0 0";
        background-color = mkLiteral "transparent";
      };

      "mainbox" = {
        spacing = mkLiteral "0px";
        children = mkLiteral "[message,inputbar,listview]";
      };

      "message" = {
        enabled = mkLiteral "true";
        margin = mkLiteral "0px 20px";
        padding = mkLiteral "15px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "15px";
        border-color = mkLiteral "inherit";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
        size = mkLiteral "400em";
      };

      "textbox" = {
        background-color = mkLiteral "none";
        text-color = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.5";
        placeholder-color = mkLiteral "inherit";
        blink = mkLiteral "true";
        size = mkLiteral "400em";
        font = mkLiteral "\"SF Pro Display 14\"";
      };

      "element" = {
        background = mkLiteral "transparent";
        children = mkLiteral "[element-icon, element-text]";
      };
      "element,element-text,element-icon, button" = {
        cursor = mkLiteral "pointer";
      };

      "inputbar" = {
        spacing = mkLiteral "0.4em";
        border-color = mkLiteral "#0D1113";
        border = mkLiteral "5px";
        border-radius = mkLiteral "10px";
        background-color = mkLiteral "#0D1113";
        children = mkLiteral "[entry,overlay,case-indicator]";
      };

      "listview, message" = {
        padding = mkLiteral "0.4em";
        margin = mkLiteral "12px 0 0 0";
        border-color = mkLiteral "#191724";
        border = mkLiteral "2px";
        border-radius = mkLiteral "10px";
        background-color = mkLiteral "#0D1113";

        columns = mkLiteral "1";
        lines = mkLiteral "8";
      };

      "element" = {
        padding = mkLiteral "0.4px";
      };

      "element-text" = {
        # background-color = mkLiteral "#0D1113";
        text-color = mkLiteral "#62707A";
      };

      "element normal.normal" = {
        # background-color = mkLiteral "#1f1d2e";
        text-color = mkLiteral "#c4a7e7";
      };

      "element.selected.normal" = {
        # background-color = mkLiteral "#26233a";
        # border-color = mkLiteral "#26233a";
        text-color = mkLiteral "#26233a";
      };

      "element.alternate.normal" = {
        # background-color = mkLiteral "#1f1d2e";
        # border-color = mkLiteral "#1f1d2e";
        text-color = mkLiteral "#e0def4";
      };

      "element-text.selected.normal" = {
        text-color = mkLiteral "#86CFC4";
        font = mkLiteral "\"SF Pro Display 14\"";
      };

      "mode-switcher" = {
        border = mkLiteral "0px";
        spacing = mkLiteral "0px";
        expand = mkLiteral "true";
      };

      "entry" = {
        font = mkLiteral "\"SF Pro Display 14\"";
        placeholder = mkLiteral "\"Buscar aplicacion\"";
        placeholder-color = mkLiteral "#242A30";
        border-color = mkLiteral "#0D1113";
        background-color = mkLiteral "#0D1113";
        border = mkLiteral "8px";
        border-radius = mkLiteral "2px 2px 2px 2px";
        text-color = mkLiteral "#e0def4";
        padding-bottom = mkLiteral "20px";
      };

    };
  };
}
