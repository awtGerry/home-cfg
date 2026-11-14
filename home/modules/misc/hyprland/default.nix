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
    ${pkgs.awww}/bin/awww-daemon &
    "random-wp" &
    ${pkgs.anyrun}/bin/anyrun daemon &
  '';
in
{
  options.wayland.windowManager.hyprland = {
    # Cada entrada es la tabla de un hl.monitor(...)
    monitors = lib.mkOption {
      type = with lib.types; listOf (attrsOf anything);
      default = [
        # Mi configuracion actual de monitores se carga por defecto
        {
          output = "DP-1";
          mode = "1920x1080@144";
          position = "1920x0";
          scale = 1;
        }
        {
          output = "HDMI-A-1";
          mode = "1920x1080@60";
          position = "0x0";
          scale = 1;
        }
      ];
      description = "Configuracion para los monitores utilizados en el sistema.";
    };

    # Cada entrada es la tabla de un hl.workspace_rule(...)
    workspaces = lib.mkOption {
      type = with lib.types; listOf (attrsOf anything);
      default = map (n: {
        workspace = toString n;
        # La 7 esta reservada para el segundo monitor
        monitor = if n == 7 then "HDMI-A-1" else "DP-1";
      }) (lib.range 1 9);
      description = "Ventanas de trabajo asignadas por monitor";
    };
  };

  imports = [ ./config ];

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      xwayland.enable = true;
      systemd.enable = true;
      configType = "lua";
      # Cada atributo se vuelve una llamada hl.<nombre>(...)
      settings = {
        config = {
          xwayland.force_zero_scaling = true;

          general = {
            gaps_in = 5;
            gaps_out = 5;
            border_size = 2;
            # no_border_on_floating = false;
            # layout = "dwindle";
          }
          // lib.optionalAttrs (config.theme.isEink && config.theme.variant == "light") {
            col = {
              active_border = "rgb(1a1a1a)";
              inactive_border = "rgb(c8c8bc)";
            };
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
            # vfr = true;
            disable_splash_rendering = true;
            disable_hyprland_logo = true;
            force_default_wallpaper = 0;
          };
        };

        monitor = cfg.monitors;
        workspace_rule = cfg.workspaces;

        on._args = [
          "hyprland.start"
          (lib.generators.mkLuaInline ''
            function()
              hl.exec_cmd(${lib.generators.toLua { } "${startupScript}/bin/start"})
            end'')
        ];
      };
    };

    # Al actualizar a 0.57 Hyprland ya creo un hyprland.lua por defecto (no
    # encontraba uno). Sin force, HM se niega a sobreescribirlo y la activacion falla.
    xdg.configFile."hypr/hyprland.lua".force = true;

    # El portal de hyprland no implementa FileChooser (hyprland-portals.conf ya pide gtk)
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    home.packages = with pkgs; [
      # Wayland packages
      xprop
      polkit
      dconf
      xwayland
      wlogout
      awww
      wl-clipboard
      wlr-randr
      slurp
      grim
      wdisplays
    ];
  };
}
