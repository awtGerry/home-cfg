_:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.helix;
in
{
  options = {
    programs.helix.enable = lib.mkEnableOption "helix";
  };

  imports = [ ./lsp.nix ];

  config = lib.mkIf cfg.enable {
    programs.helix = {
      settings = {
        theme = "nightfox";
        editor = {
          line-number = "relative";
          lsp.display-messages = true;
        };
        keys.normal = {
          # Ctrl-c como en vim
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
