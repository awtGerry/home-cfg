{ lib, pkgs, config, ... }:

# swww img road.jpg --transition-type=wipe --transition-step=90
let
  dir = "${config.home.picDir}/Wallpapers";

  # use rofi to select the wallpaper
  rofi_config = "${config.home.configDirectory}/package/rofi/config/left_menu.rasi";
  rofi-wp = pkgs.writeShellScriptBin "rofi-wp" ''
    #!/bin/sh
    swww img ${dir}/$(ls ${dir} | rofi -dmenu -i -mesg "Select a wallpaper" -config ${rofi_config}) --transition-type=wipe --transition-angle=25 --transition-step=90 --transition-fps=200
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
    random-wp
  ];
}
