_:
{ config, lib, ... }:
let
  cfg = config.programs.helix;
in
{

  config = lib.mkIf cfg.enable {
    programs.helix = {
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
          lsp.display-inlay-hints = true;
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
