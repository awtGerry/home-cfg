_:
{ config, lib, ... }:
let
  cfg = config.programs.ghostty;
in
{
  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      settings = {
        # Hacer al tema gruvbox su variante 'dark hard'
        theme =
          if config.theme.scheme == "gruvbox" then
            "GruvboxDarkHard"
          else if config.theme.scheme == "rose_pine" then
            "rose-pine"
          else
            config.theme.scheme;
        font-size = 16;
        font-family = "Fira Code";
        confirm-close-surface = false;
        gtk-titlebar = false;
      };
    };
  };
}
