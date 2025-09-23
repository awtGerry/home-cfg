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
          else if config.theme.scheme == "rose_pine" then
            "rose-pine"
          else if config.theme.scheme == "nightfox" then
            "Nightfox"
          else
            config.theme.scheme;
        font-size = 18;
        font-family = "Fira Code";
        confirm-close-surface = false;
        gtk-titlebar = false;
      };
    };
  };
}
