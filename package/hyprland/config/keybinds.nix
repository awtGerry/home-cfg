{ config, lib, pkgs, inputs, ... }: 

let
  rofi_command = "rofi -show drun -show-icons";
  term = "wezterm";
in
{
  wayland.windowManager.hyprland.settings = {
    # keybindings
    "$mod" = "SUPER";
    bind =
    [
      # System
      "$mod, Q, killactive"
      "$mod, Backspace, exec, wlogout"
      "$mod CTRL, Backspace, exec, hyprctl dispatch exit"

      "$mod, Print, exec, screenshot"

      # Workspaces & windows
      "$mod, Tab, workspace, previous"
      "$mod, k, cyclenext"
      "$mod, k, bringactivetotop"
      "$mod, j, cyclenext, prev"
      "$mod, j, bringactivetotop"
      "$mod, F, fullscreen"
      "$mod, Space, togglefloating"

      # Programs
      "$mod, Return, exec, ${term}"
      "$mod, W, exec, firefox"
      "$mod CTRL, W, exec, chromium"
      "$mod, E, exec, ${term} -e nvim"
      "$mod, P, exec, ${rofi_command}"
      "$mod SHIFT, P, exec, gimp"
      "$mod, A, exec, ${term} -e pulsemixer"
      # Wallpapers
      "$mod, S, exec, rofi-wp"
      "$mod SHIFT, S, exec, random-wp"
      "$mod CTRL, S, exec, setbg"
      # System hardware
      "$mod, D, exec, ${term} -e duf"
      "$mod SHIFT, D, exec, ${term} -e btop"
      # Media
      "$mod, X, exec, steam"
      "$mod SHIFT, X, exec, lutris"
      "$mod, B, exec, ${term} -e bluetoothctl"
      "$mod, M, exec, thunderbird"
      "$mod SHIFT, M, exec, spotify"
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
}
