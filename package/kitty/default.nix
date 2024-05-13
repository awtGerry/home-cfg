{ lib, pkgs, config, ... }:

{
  programs.kitty = {
    enable = true;

    settings = {
      font_family = "Fira Code Nerd Font Mono";
      font_size = 16;
      enable_audio_bell = false;
      confirm_os_window_close = 0;
    };
    theme = "Gruvbox Material Dark Hard";
  };
}
