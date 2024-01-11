{ lib, pkgs, config, ... }:

{
  programs.kitty = {
    enable = true;

    settings = {
      font_family = "Fira Code Nerd Font Mono";
      font_size = 16;
      
      # Remove bell
      enable_audio_bell = false;
    };
  };
}
