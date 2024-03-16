{ config, lib, pkgs, inputs, ... }: 

let
  rofi_command = "rofi -show drun -show-icons";

  # Randomly choose a wallpaper in ~/Pictures/Wallpapers
  random-wallpaper = pkgs.writeShellScript "random-wallpaper" ''
    ${pkgs.findutils}/bin/find -L ~/Pictures/Wallpapers -type f | ${pkgs.coreutils}/bin/shuf -n 1
  '';

  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
      ${pkgs.waybar}/bin/waybar &
      ${pkgs.swaybg}/bin/swaybg -i $(random-wallpaper) &
  '';
in
{
  home.packages = with pkgs; [
    wl-clipboard
    wlr-randr
    swaylock
    swaybg
    slurp
    hyprpaper
    # Screenshots
    # grim
    # grimblast
  ];
  wayland.windowManager.hyprland.settings = {

    exec-once = ''${startupScript}/bin/start'';

    # general settings
    general = {
      monitor = [
        "DP-1,1920x1080@144,0x0,1"
      ];
      border_size = 1;
    };

    # keyboard
    input = {
      repeat_rate = 50;
      repeat_delay = 300;
    };

    # keybindings
    "$mod" = "SUPER";
    bind =
      [
        "$mod, Q, killactive"
        "$mod, W, exec, firefox"
        "$mod, P, exec, ${rofi_command}"
        "$mod, Return, exec, wezterm"
        "$mod, T, exec, kitty"
        ", Print, exec, grimblast copy area"
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
  };
}
