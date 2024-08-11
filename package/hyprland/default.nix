{ config, lib, pkgs, inputs, ... }: 

let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
      ${pkgs.waybar}/bin/waybar &
      ${pkgs.swww}/bin/swww init &
      "random-wp" &
  '';
in
{
  imports = [
    ./config
    ./wlogout.nix
  ];

  wayland.windowManager.hyprland.settings = {
    xwayland.force_zero_scaling = true;
    exec-once = ''${startupScript}/bin/start'';

    # general settings
    general = {
      monitor = [
        "DP-1,1920x1080@144,0x0,1"
      ];
      gaps_in = 5;
      gaps_out = 5;
      border_size = 2;
      "no_border_on_floating" = false;
      layout = "dwindle";
      allow_tearing = true;
      # no_cursor_warp = true;
    };

    # keyboard
    input = {
      repeat_rate = 50;
      repeat_delay = 300;
    };
  };
}
