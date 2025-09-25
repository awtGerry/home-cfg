_:
{ config, lib, ... }:
let
  cfg = config.programs.ghostty;
in
{
  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      settings = {
        # TODO: Mejor manera de renombrar?
        theme =
          if config.theme.scheme == "gruvbox" then
            "GruvboxDarkHard"
          else if config.theme.scheme == "nightfox" then
            "Nightfox"
          else if config.theme.scheme == "ayu_dark" then
            "Ayu"
          else if config.theme.scheme == "ayu_light" then
            "Ayu Light"
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
