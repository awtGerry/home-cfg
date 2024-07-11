{ lib, pkgs, config, ... }:

let
  hostname = "${pkgs.runCommand "hostname" {} ''hostname''}"; # check if there is a nix way to do this.
in
{
  programs.kitty = {
    enable = true;

    settings = {
      font_family = "Fira Code Nerd Font Mono";
      font_size = if hostname == "lyra" then 16 else 13; # 15 for main 13 for laptops
      enable_audio_bell = false;
      confirm_os_window_close = 0;
    };
    theme = "Catppuccin-Mocha";
  };
}
