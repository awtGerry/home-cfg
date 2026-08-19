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

  isEinkLight = config.theme.isEink && config.theme.variant == "light";
  tc = config.theme.colors;

  colors =
    if isEinkLight then
      {
        muted = tc.comment;
        normal = tc.fg-alt;
        text = tc.fg;
        input-bg = tc.bg-alt;
        input-border = tc.accent;
        selected-bg = tc.selection;
        selected-text = tc.fg;
        placeholder = tc.comment;
      }
    else
      {
        muted = "#62707A";
        normal = "#c4a7e7";
        text = "#e0def4";
        input-bg = "#0D1113";
        input-border = "#0D1113";
        selected-bg = "#26233a";
        selected-text = "#86CFC4";
        placeholder = "#242A30";
      };
in
{
  config = lib.mkIf cfg.enable {
    # TODO: Implementar esto con colores?
    programs.rofi.theme = {
      "*" = {
        background-color = mkLiteral "transparent";
        foreground-color = mkLiteral colors.muted;
      };

      "configuration" = {
        font = mkLiteral "\"SF Pro Display 14\"";
      };

      "prompt" = {
        enabled = mkLiteral "true";
        font = mkLiteral "\"Font Awesome 6 Free Solid 12\"";
        text = mkLiteral "\"\"";
        background-color = mkLiteral "transparent";
        foreground-color = mkLiteral colors.muted;
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
        border-color = mkLiteral colors.input-border;
        border = mkLiteral "5px";
        border-radius = mkLiteral "10px";
        background-color = mkLiteral colors.input-bg;
        children = mkLiteral "[entry,overlay,case-indicator]";
      };

      "listview, message" = {
        padding = mkLiteral "0.4em";
        margin = mkLiteral "12px 0 0 0";
        border-color = mkLiteral colors.input-border;
        border = mkLiteral "2px";
        border-radius = mkLiteral "10px";
        background-color = mkLiteral colors.input-bg;

        columns = mkLiteral "1";
        lines = mkLiteral "8";
      };

      "element" = {
        padding = mkLiteral "0.4px";
      };

      "element-text" = {
        text-color = mkLiteral colors.muted;
      };

      "element normal.normal" = {
        text-color = mkLiteral colors.normal;
      };

      "element.selected.normal" = {
        background-color = mkLiteral colors.selected-bg;
        text-color = mkLiteral colors.selected-text;
      };

      "element.alternate.normal" = {
        text-color = mkLiteral colors.text;
      };

      "element-text.selected.normal" = {
        text-color = mkLiteral colors.selected-text;
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
        placeholder-color = mkLiteral colors.placeholder;
        border-color = mkLiteral colors.input-border;
        background-color = mkLiteral colors.input-bg;
        border = mkLiteral "8px";
        border-radius = mkLiteral "2px 2px 2px 2px";
        text-color = mkLiteral colors.text;
        padding-bottom = mkLiteral "20px";
      };

    };
  };
}
