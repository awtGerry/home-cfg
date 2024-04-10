{ config, pkgs, ... }: 

let
  swaymsg = "${config.wayland.windowManager.sway.package}/bin/swaymsg";

  # Turn off scaling on all displays
  scale-off = pkgs.writeShellScript "scale-off" ''
    rm -rf /tmp/scale-on
    mkdir /tmp/scale-on

    while read -r scale name; do
      echo "$scale" > "/tmp/scale-on/$name";
    done < <(${swaymsg} -r -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | "\(.scale) \(.make) \(.model) \(.serial)"')

    ${swaymsg} 'output * scale 1'
  '';

  # Turn on scaling on all displays
  scale-on = pkgs.writeShellScript "scale-on" ''
    for scale_file in /tmp/scale-on/*; do
      ${swaymsg} "output \"$(basename "$scale_file")\" scale $(${pkgs.coreutils}/bin/cat "$scale_file")"
    done
  '';

  # Turn off scaling on all displays for the duration of the wrapped program
  wrap-scale-off = pkgs.writeShellScriptBin "wrap-scale-off" ''
    ${scale-off}
    export MANGOHUD_CONFIGFILE=$HOME/.config/MangoHud/MangoHud.conf
    "$1" "''${@:2}"
    ${scale-on}
  '';
in
{
  imports = [
    ./visuals.nix
    ./keybinds.nix
  ];
  home.packages = with pkgs; [
    wrap-scale-off
  ];
}
