_:
{ config, lib, ... }:
let
  cfg = config.programs.ghostty;
  isEink = config.theme.isEink;
  colors = config.theme.colors;
in
{
  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      # Tema e-ink (grises) generado desde config.theme.colors
      themes = lib.mkIf isEink {
        "e-ink" = {
          background = colors.bg;
          foreground = colors.fg;
          cursor-color = colors.cursor;
          cursor-text = colors.bg;
          selection-background = colors.selection;
          selection-foreground = colors.fg;
          palette = [
            "0=${colors.fg}"
            "1=${colors.fg-alt}"
            "2=${colors.string}"
            "3=${colors.info}"
            "4=${colors.keyword}"
            "5=${colors.operator}"
            "6=${colors.constant}"
            "7=${colors.comment}"
            "8=${colors.hint}"
            "9=${colors.warning}"
            "10=${colors.string}"
            "11=${colors.info}"
            "12=${colors.keyword}"
            "13=${colors.operator}"
            "14=${colors.fg-alt}"
            "15=${colors.fg-alt}"
          ];
        };
      };

      settings = {
        # TODO: Mejor manera de renombrar?
        theme =
          if isEink then
            "e-ink"
          else if config.theme.scheme == "gruvbox" then
            "Gruvbox Dark Hard"
          else if config.theme.scheme == "rose_pine" then
            "Rose Pine"
          else if config.theme.scheme == "nightfox" then
            "Nightfox"
          else if config.theme.scheme == "ayu_evolve" then
            "Ayu"
          else if config.theme.scheme == "ayu_light" then
            "Ayu Light"
          else if config.theme.scheme == "gruber-darker" then
            "Gruber Darker"
          # TODO: Generar colores para curzon en ghostty
          else if config.theme.scheme == "curzon" then
            "Gruvbox Dark Hard"
          else
            config.theme.scheme;
        font-size = 18;
        font-family = "Fira Code";
        confirm-close-surface = false;
        window-padding-x = 3;
        window-padding-y = 3;
        background-opacity = 0.8;
        gtk-titlebar = false;
      };
    };
  };
}
