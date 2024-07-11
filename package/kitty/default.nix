{ lib, pkgs, osConfig, config, ... }:

{
  programs.kitty = {
    enable = true;

    settings = {
      font_family = "Fira Code Nerd Font Mono";
      font_size = if osConfig.networking.hostName == "lyra" then 18 else 13;
      enable_audio_bell = false;
      confirm_os_window_close = 0;
    };

    theme = "Catppuccin-Mocha";
  };
}
