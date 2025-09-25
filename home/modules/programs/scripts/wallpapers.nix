{ pkgs, config, ... }:

let
  dir = "$HOME/Pictures/Wallpapers";
  launcher-cmd =
    if config.apps.launcher == "rofi" then
      "${config.apps.launcher} -dmenu -i -mesg \"Select a wallpaper\""
    # anyrun case (Wayland)
    else
      "${config.apps.launcher} --plugins libstdin.so --show-results-immediately true --hide-icons true --hide-plugin-info true";

  fzf-wp = pkgs.writeShellScriptBin "fzf-wp" ''
    #!/bin/sh
    if [ -n "$WAYLAND_DISPLAY" ]; then
      swww img ${dir}/$(ls ${dir} | ${launcher-cmd}) --transition-type=wipe --transition-angle=25 --transition-step=90 --transition-fps=200
    else
      # make a symbolic link to the selected wallpaper in ~/Pictures/.wallpaper
      # this file is referenced in DWM config.
      selected=$(ls ${dir} | rofi -dmenu -i -mesg "Select a wallpaper")

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
    fzf-wp
    random-wp
  ];
}
