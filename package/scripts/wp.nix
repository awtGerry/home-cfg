{ lib, pkgs, config, ... }:

# swww img road.jpg --transition-type=wipe --transition-step=90
let
  dir = "${config.home.picDir}/Wallpapers";

  # use rofi to select the wallpaper
  rofi_config = "${config.home.configDirectory}/package/rofi/config/opt_menu.rasi";
  rofi-wp = pkgs.writeShellScriptBin "rofi-wp" ''
    #!/bin/sh
    swww img ${dir}/$(ls ${dir} | rofi -dmenu -i -mesg "Select a wallpaper" -config ${rofi_config}) --transition-type=wipe --transition-angle=25 --transition-step=90 --transition-fps=200
  '';

  # script to change the wallpaper depending on the time of the day
  setbg = pkgs.writeShellScriptBin "setbg" ''
    #!/bin/sh
    case $(date +%H) in
      05 | 06 | 07 | 08 | 09 | 10 | 11)
        swww img ${dir}/anime-beach.jpg
        ;;
      12 | 13 | 14 | 15 | 16 | 17)
        swww img ${dir}/road.jpg
        ;;
      18 | 19 | 20 | 21 | 22 | 23)
        swww img ${dir}/mustang.jpg
        ;;
    esac
  '';

  # Random wallpaper
  random-wp = pkgs.writeShellScriptBin "random-wp" ''
    #!/bin/sh
    swww img ${dir}/$(ls ${dir} | shuf -n 1) --transition-type=wipe --transition-angle=25 --transition-step=90 --transition-fps=200
  '';
in
{
  home.packages = [
    rofi-wp
    setbg
    random-wp
  ];
}
