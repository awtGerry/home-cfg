{ config, lib, pkgs, inputs, ... }: 

let
  swaymsg = "${config.wayland.windowManager.sway.package}/bin/swaymsg";
  rofi_command = "rofi -show drun -show-icons";

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

  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
      ${pkgs.waybar}/bin/waybar &
      ${pkgs.hyprpaper}/bin/hyprpaper &
  '';

  # Turn off scaling on all displays for the duration of the wrapped program
  wrap-scale-off = pkgs.writeShellScriptBin "wrap-scale-off" ''
    ${scale-off}
    export MANGOHUD_CONFIGFILE=$HOME/.config/MangoHud/MangoHud-HiDPI.conf
    "$1" "''${@:2}"
    ${scale-on}
  '';
in
{
  imports = [ ./hyprpaper.nix ];
  wayland.windowManager.hyprland.settings = {

    exec-once = ''${startupScript}/bin/start'';

    # general settings
    general = {
      monitor = [
        "DP-1,1920x1080@144,0x0,1"
      ];
      gaps_in = 5;
      gaps_out = 5;
      border_size = 1;
      "col.active_border" = "rgb(255, 0, 0)";
      "col.inactive_border" = "rgb(0, 0, 0)";
      "no_border_on_floating" = false;
      layout = "dwindle";
      no_cursor_warps = true;
    };

    # keyboard
    input = {
      repeat_rate = 50;
      repeat_delay = 300;
    };

    /* misc = {
      disable_autoreload = true;
      animate_mouse_windowdragging = false;
      vrr = 2;
      # no_direct_scanout = false;
      vfr = true;
      # disable_splash_rendering = true;
      disable_hyprland_logo = true;
      force_default_wallpaper = 0;
    }; */

    decoration = {
      rounding = 1;
      /* blur = {
        size = 6;
        passes = 3;
        new_optimizations = true;
        ignore_opacity = true;
        noise = "0.1";
        contrast = "1.1";
        brightness = "1.2";
        xray = true;
      }; */
      dim_inactive = true;
      dim_strength = "0.3";
/*       fullscreen_opacity = 1; */
      drop_shadow = true;
      shadow_ignore_window = true;
      shadow_offset = "0 8";
      shadow_range = 50;
      shadow_render_power = 3;
      "col.shadow" = "rgba(00000055)";
      blurls = ["lockscreen" "waybar" "popups"];
    };
    animation = {
      bezier = [
        "fluent_decel, 0, 0.2, 0.4, 1"
        "easeOutCirc, 0, 0.55, 0.45, 1"
        "easeOutCubic, 0.33, 1, 0.68, 1"
        "easeinoutsine, 0.37, 0, 0.63, 1"
      ];
      animation = [
        "windowsIn, 1, 1.7, easeOutCubic, slide" # window open
        "windowsOut, 1, 1.7, easeOutCubic, slide" # window close
        "windowsMove, 1, 2.5, easeinoutsine, slide" # everything in between, moving, dragging, resizing

        # fading
        "fadeIn, 1, 3, easeOutCubic" # fade in (open) -> layers and windows
        "fadeOut, 1, 3, easeOutCubic" # fade out (close) -> layers and windows
        "fadeSwitch, 1, 5, easeOutCirc" # fade on changing activewindow and its opacity
        "fadeShadow, 1, 5, easeOutCirc" # fade on changing activewindow for shadows
        "fadeDim, 1, 6, fluent_decel" # the easing of the dimming of inactive windows
        "border, 1, 2.7, easeOutCirc" # for animating the border's color switch speed
        "workspaces, 1, 2, fluent_decel, slide" # styles: slide, slidevert, fade, slidefade, slidefadevert
        "specialWorkspace, 1, 3, fluent_decel, slidevert"
      ];
    };

    dwindle = {
      no_gaps_when_only = true;
      pseudotile = true;
      preserve_split = true;
    };

    # keybindings
    "$mod" = "SUPER";
    bind =
      [
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$mod, Space, togglefloating"
        "$mod, Tab, cyclenext"
        "$mod, Tab, bringactivetotop"

        "$mod CTRL, Q, exec, hyprctl dispatch exit"
        "$mod, W, exec, firefox"
        "$mod CTRL, W, exec, chromium"
        "$mod, P, exec, ${rofi_command}"
        "$mod, Return, exec, kitty"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );
    bindm = [
      # mouse movements
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod ALT, mouse:272, resizewindow"
    ];
  };

  home.packages = with pkgs; [
    wrap-scale-off
  ];
}
