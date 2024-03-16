{ config, pkgs, ... }: 

{
  wayland.windowManager.hyprland.settings = {
    general = {
      monitor = [
        "DisplayPort-0,1920x1080@144,0x0,0"
      ];
    };

    decoration = {
      shadow_offset = "0 5";
      "col.shadow" = "rgba(00000099)";
    };


    "$mod" = "SUPER";

    bind = [
      # mouse movements
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod ALT, mouse:272, resizewindow"

      "$mod, Return, exec, wezterm"
      "$mod, T, exec, wezterm"
      "$mod, W, exec, firefox"
      "$mod CTRL, q, exec, hyprctl dispatch exit"
    ]
    ++ (
      builtins.concatLists (builtins.genList (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c * 10));
        in [
          "$mod ${ws}, workspace ${toString (x + 1)}"
          "$mod SHIFT ${ws}, movetoworkspace ${toString (x + 1)}"
        ]
      )
      10)
    );
  };
}
