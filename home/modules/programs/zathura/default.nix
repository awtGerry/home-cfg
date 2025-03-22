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
in
{
  config = lib.mkIf cfg.enable {
    programs.zathura = {
      options = {
        window-title-basename = true;
        selection-clipboard = "clipboard";
        save-position = true;
        recolor = true;

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
        # highlight-color = "#D68EB2";
        # highlight-active-color = "#ff79c6";
        default-bg = "#18191E";
        default-fg = "#FFEE79";
        render-loading = true;
        render-loading-fg = "#FFEE79";
        render-loading-bg = "#18191E";

        # Recolor mode settings
        recolor-lightcolor = "#21252D";
        recolor-darkcolor = "#FFFADE";
      };
    };
  };
}
