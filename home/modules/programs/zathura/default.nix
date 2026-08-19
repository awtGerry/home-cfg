_:
{
  pkgs,
  lib,
  config,
  ...
}:

# Source: https://github.com/lighthaus-theme/zathura/blob/master/src/zathurarc

let
  cfg = config.programs.zathura;
  isEinkLight = config.theme.isEink && config.theme.variant == "light";
in
{
  config = lib.mkIf cfg.enable {
    programs.zathura = {
      options =
        {
          window-title-basename = true;
          selection-clipboard = "clipboard";
          save-position = true;
          recolor = true;
          render-loading = true;
        }
        // (
          if isEinkLight then
            {
              notification-error-bg = "#F85552";
              notification-error-fg = "#fffff8";
              notification-warning-bg = "#DFA000";
              notification-warning-fg = "#1a1a1a";
              notification-bg = "#e6e6da";
              notification-fg = "#1a1a1a";
              completion-bg = "#f5f5ec";
              completion-fg = "#1a1a1a";
              completion-group-bg = "#f5f5ec";
              completion-group-fg = "#4a4a4a";
              completion-highlight-bg = "#d4d4c8";
              completion-highlight-fg = "#1a1a1a";
              index-bg = "#f5f5ec";
              index-fg = "#1a1a1a";
              index-active-bg = "#d4d4c8";
              index-active-fg = "#1a1a1a";
              inputbar-bg = "#e6e6da";
              inputbar-fg = "#1a1a1a";
              statusbar-bg = "#4a4a4a";
              statusbar-fg = "#fffff8";
              default-bg = "#fffff8";
              default-fg = "#1a1a1a";
              render-loading-fg = "#1a1a1a";
              render-loading-bg = "#fffff8";

              # Recolor mode settings
              recolor-lightcolor = "#fffff8";
              recolor-darkcolor = "#1a1a1a";
            }
          else
            {
              # Lighthaus Colors:
              notification-error-bg = "#FC2929";
              notification-error-fg = "#18191E";
              notification-warning-bg = "#E25600";
              notification-warning-fg = "#18191E";
              notification-bg = "#D68EB2";
              notification-fg = "#18191E";
              completion-bg = "#18191E";
              completion-fg = "#44B273";
              completion-group-bg = "#18191E";
              completion-group-fg = "#ED722E";
              completion-highlight-bg = "#FFFF00";
              completion-highlight-fg = "#21252D";
              index-bg = "#18191E";
              index-fg = "#44B273";
              index-active-bg = "#21252D";
              index-active-fg = "#FFFF00";
              inputbar-bg = "#21252D";
              inputbar-fg = "#FFFADE";
              statusbar-bg = "#21252D";
              statusbar-fg = "#D68EB2";
              default-bg = "#18191E";
              default-fg = "#FFEE79";
              render-loading-fg = "#FFEE79";
              render-loading-bg = "#18191E";

              # Recolor mode settings
              recolor-lightcolor = "#21252D";
              recolor-darkcolor = "#FFFADE";
            }
        );

      mappings = {
        "<C-r>" = "set recolor"; # Ctrl+r to toggle light/dark mode
      };
    };
  };
}
