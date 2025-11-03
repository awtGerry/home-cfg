# Configuraciones generales para hyprland
# -> Programas que se inician junto con el wm
# -> Ventanas de trabajo y monitores
# -> Mejoras generales

_:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.wayland.windowManager.hyprland;
  startupScript = pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww-daemon &
    "random-wp" &
  '';
in
{
  options.wayland.windowManager.hyprland = {
    monitors = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        # Mi configuracion actual de monitores se carga por defecto
        "DP-1,1920x1080@144,1920x0,1"
        "HDMI-A-1,1920x1080@60,0x0,1"
      ];
      description = "Configuracion para los monitores utilizados en el sistema.";
    };

    workspaces = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "1, monitor:DP-1"
        "2, monitor:DP-1"
        "3, monitor:DP-1"
        "4, monitor:DP-1"
        "5, monitor:DP-1"
        "6, monitor:DP-1"
        "7, monitor:HDMI-A-1" # Esta ventana de trabajo estara reservada para el segundo monitor
        "8, monitor:DP-1"
        "9, monitor:DP-1"
      ];
      description = "Ventanas de trabajo asignadas por monitor";
    };
  };

  imports = [ ./config ];

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      xwayland.enable = true;
      systemd.enable = true;
      settings = {
        xwayland.force_zero_scaling = true;
        exec-once = ''${startupScript}/bin/start'';

        general = {
          monitor = cfg.monitors;
          workspace = cfg.workspaces;
          gaps_in = 5;
          gaps_out = 5;
          border_size = 2;
          "no_border_on_floating" = false;
          layout = "dwindle";
        };

        # Configuraciones del teclado (lo hace un poco mas veloz) y mouse cursor
        input = {
          repeat_rate = 50;
          repeat_delay = 300;
        };

        misc = {
          disable_autoreload = true;
          animate_mouse_windowdragging = false;
          # no_direct_scanout = false;
          vfr = true;
          disable_splash_rendering = true;
          disable_hyprland_logo = true;
          force_default_wallpaper = 0;
        };
      };
    };

    home.packages = with pkgs; [
      # Wayland packages
      xorg.xprop
      polkit
      dconf
      xwayland
      wlogout
      swww
      wl-clipboard
      wlr-randr
      slurp
      grim
      wdisplays
    ];
  };
}
