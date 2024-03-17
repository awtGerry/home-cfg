{ lib, pkgs, ... }:

let
  bg = "~/Pictures/Wallpapers/mustang.jpg";
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
