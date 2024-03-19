{ config, lib, pkgs, inputs, ... }: 

let
  rofi_command = "rofi -show drun -show-icons";
in
{
  wayland.windowManager.hyprland.settings = {
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
      "$mod, E, exec, neovim"
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
}