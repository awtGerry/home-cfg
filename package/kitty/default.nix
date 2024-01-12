{ lib, pkgs, config, ... }:

{
  programs.kitty = {
    enable = true;

    settings = {
      font_family = "Fira Code Nerd Font Mono";
      font_size = 16;
      
      # Remove bell
      enable_audio_bell = false;

      # Transparency
      background_opacity = "0.8";
      # Blur
      # background_blur = 0.5;
    };
  };
}
