{ pkgs, config, ... }:

let
  dir = "$HOME/Pictures/Wallpapers";

  # use rofi to select the wallpaper
  rofi_config = "${config.dirs.repoDir}/home/modules/misc/rofi/config/dark.rasi";
  rofi-wp = pkgs.writeShellScriptBin "rofi-wp" ''
    #!/bin/sh
    if [ -n "$WAYLAND_DISPLAY" ]; then
      swww img ${dir}/$(ls ${dir} | rofi -dmenu -i -mesg "Select a wallpaper" -config ${rofi_config}) --transition-type=wipe --transition-angle=25 --transition-step=90 --transition-fps=200
    else
      # make a symbolic link to the selected wallpaper in ~/Pictures/.wallpaper
      # this file is referenced in DWM config.
      selected=$(ls ${dir} | rofi -dmenu -i -mesg "Select a wallpaper" -config ${rofi_config})
      # if none (or selected is Wallpaper) is selected, do nothing
      [ -z "$selected" ] && exit 0
      ln -sf ${dir}/$selected $HOME/Pictures/.wallpaper
      xwallpaper --zoom $HOME/Pictures/.wallpaper
    fi
  '';

  # Random wallpaper (right now only available for wayland)
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
