_:
{ config, lib, ... }:
let
  cfg = config.programs.helix;
  isEink = config.theme.isEink;
  colors = config.theme.colors;
in
{

  config = lib.mkIf cfg.enable {
    programs.helix = {
      # Tema e-ink (monocromatico) generado desde config.theme.colors
      themes = lib.mkIf isEink {
        ${config.theme.scheme} = {
          "ui.background" = {
            fg = "fg";
            bg = "bg";
          };
          "ui.text" = {
            fg = "fg";
          };
          "ui.cursor" = {
            fg = "bg";
            bg = "fg";
          };
          "ui.cursor.primary" = {
            fg = "bg";
            bg = "fg";
          };
          "ui.cursorline.primary" = {
            bg = "cursorline";
          };
          "ui.selection" = {
            bg = "selection";
          };
          "ui.selection.primary" = {
            bg = "selection";
          };
          "ui.highlight" = {
            bg = "selection";
          };
          "ui.cursor.match" = {
            fg = "fg";
            modifiers = [ "bold" ];
          };
          "ui.linenr" = {
            fg = "comment";
          };
          "ui.linenr.selected" = {
            fg = "fg";
          };
          "ui.statusline" = {
            fg = "bg";
            bg = "fg-alt";
          };
          "ui.statusline.inactive" = {
            fg = "fg-alt";
            bg = "bg-alt";
          };
          "ui.popup" = {
            bg = "bg-alt";
          };
          "ui.window" = {
            fg = "border";
          };
          "ui.help" = {
            fg = "fg";
            bg = "bg-alt";
          };
          "ui.menu" = {
            fg = "fg";
            bg = "bg-alt";
          };
          "ui.menu.selected" = {
            bg = "selection";
          };
          "ui.virtual.whitespace" = {
            fg = "border";
          };

          # Sintaxis: grises, distincion por peso/estilo
          "comment" = {
            fg = "comment";
            modifiers = [ "italic" ];
          };
          "keyword" = {
            fg = "keyword";
            modifiers = [ "bold" ];
          };
          "string" = {
            fg = "string";
          };
          "function" = {
            fg = "function";
            modifiers = [ "bold" ];
          };
          "type" = {
            fg = "type";
          };
          "constant" = {
            fg = "constant";
          };
          "variable" = {
            fg = "variable";
          };
          "variable.builtin" = {
            fg = "variable";
            modifiers = [ "italic" ];
          };
          "operator" = {
            fg = "operator";
          };
          "punctuation" = {
            fg = "operator";
          };
          "tag" = {
            fg = "keyword";
          };
          "attribute" = {
            fg = "operator";
          };
          "namespace" = {
            fg = "type";
          };
          "markup.heading" = {
            fg = "function";
            modifiers = [ "bold" ];
          };
          "markup.bold" = {
            modifiers = [ "bold" ];
          };
          "markup.italic" = {
            modifiers = [ "italic" ];
          };
          "markup.link.url" = {
            fg = "comment";
            modifiers = [ "underlined" ];
          };
          "diff.plus" = {
            fg = "fg-alt";
          };
          "diff.minus" = {
            fg = "fg";
            modifiers = [ "crossed_out" ];
          };
          "diff.delta" = {
            fg = "comment";
          };

          # Diagnosticos: solo subrayado, sin color
          "diagnostic.error" = {
            underline = {
              style = "curl";
            };
          };
          "diagnostic.warning" = {
            underline = {
              style = "curl";
            };
          };
          "diagnostic.info" = {
            underline = {
              style = "dotted";
            };
          };
          "diagnostic.hint" = {
            underline = {
              style = "dotted";
            };
          };

          palette = colors;
        };
      };

      settings = {
        # theme = config.theme.scheme;
        # TODO: Mejorar estos metodos
        theme =
          if config.theme.scheme == "gruvbox" then
            "gruvbox_dark_hard"
          else if config.theme.scheme == "tokyonight-day" then
            "tokyonight_day"
          else
            config.theme.scheme;

        editor = {
          line-number = "relative";
          lsp.display-messages = true;
          lsp.display-inlay-hints = false;
          cursorline = true;
          color-modes = true;
          true-color = true;

          # uncomment if you want auto-pairs
          auto-pairs = false;

          whitespace.characters.newline = "⤶";
        };
        keys.normal = {
          # Utilizar ctrl-c para escape
          C-c = [
            "keep_primary_selection"
            "collapse_selection"
          ];
          "$" = "goto_line_end";
          "V" = "extend_line_below";
          "0" = "goto_line_start";
          "H" = ":set lsp.display-inlay-hints false";
          "L" = ":set lsp.display-inlay-hints false";
        };

        keys.insert = {
          C-c = [ "normal_mode" ];
        };

        keys.select = {
          C-c = [
            "normal_mode"
            "keep_primary_selection"
            "collapse_selection"
          ];
          "u" = "switch_to_lowercase";
          "U" = "switch_to_uppercase";
          "$" = "goto_line_end";
          "0" = "goto_line_start";
        };
      };
    };
  };
}
