{ lib, pkgs, config, ... }:

{
  programs.kitty = {
    enable = true;

    settings = {
      font_family = "Fira Code Nerd Font Mono";
      font_size = 18; # I'm kinda blind :(
      enable_audio_bell = false;
      confirm_os_window_close = 0;
    };
    theme = "Catppuccin-Mocha";
  };
}
