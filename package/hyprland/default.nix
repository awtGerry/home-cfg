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
        "HDMI-A-1,disable"
      ];
      gaps_in = 5;
      gaps_out = 5;
      border_size = 2;
      "no_border_on_floating" = false;
      layout = "dwindle";
      # allow_tearing = true;
    };

    # keyboard
    input = {
      repeat_rate = 50;
      repeat_delay = 300;
    };

    misc = {
      disable_autoreload = true;
      animate_mouse_windowdragging = false;
      # vrr = 2;
      no_direct_scanout = false;
      vfr = true;
      disable_splash_rendering = true;
      disable_hyprland_logo = true;
      force_default_wallpaper = 0;
    };

  };
}
