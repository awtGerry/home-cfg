{ lib, pkgs, config, ... }:

let
  bg = "~/Pictures/Wallpapers/road.jpg";
  # bg = "${config.home.picDir.file}/Wallpapers/road.jpg";
in
{
  home.file = {
    ".config/hypr/hyprpaper.conf".text = ''
      preload = ${bg}
      wallpaper = ,${bg}
      ipc = off
      splash = false
    '';
  };
}
