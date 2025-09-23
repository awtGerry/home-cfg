{ config, lib, ... }:

let
  cfg = config.wayland.windowManager.hyprland;

  # Definir las aplicaciones usadas en el sistema
  # TODO: Mejor variables globales para las aplicaciones? ...
  defaultApps = {
    terminal = config.apps.terminal;
    altBrowser = "chromium";
    editor = config.apps.editor;
    launcher = "${config.apps.launcher} -show drun -show-icons";
    mixer = "pulsemixer";
    imageEditor = "gimp";
    diskUsage = "duf";
    systemMonitor = "btop";
    gameClient = "steam";
    gameLauncher = "lutris";
    bluetooth = "bluetoothctl";
    email = "thunderbird";
    music = "rmpc";
  };
  # Toma screenshot fullscreen (wayland)
  mkScreenshotCmd =
    dir:
    "grim -o $(hyprctl -j activeworkspace | jq -r '.monitor') ${dir}/$(date +%Y-%m-%d_%H-%M-%S).png";
in
{
  options.wayland.windowManager.hyprland = {
    # Atajos de teclado
    bindings = {
      # NOTE: La tecla por defecto es la de windows (opt/start)
      modKey = lib.mkOption {
        type = lib.types.str;
        default = "SUPER";
        description = "Main modifier key";
      };

      apps = lib.mkOption {
        type = with lib.types; attrsOf str;
        default = defaultApps;
        description = "Define las aplicaciones las cuales tendran atajos de teclado";
      };

      screenshotDir = lib.mkOption {
        type = lib.types.str;
        default = "${config.xdg.userDirs.pictures}/screenshots/full";
        description = "Define el directorio en el cual se guardaran imagenes"; # Por defecto: ~/Pictures/screenshots/**
      };

      extraBinds = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        description = "Atajos adicionales";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      "$mod" = cfg.bindings.modKey;

      bind =
        # Atajos del sistema
        [
          "$mod, Q, killactive"
          "$mod, Backspace, exec, wlogout"
          "$mod CTRL, Backspace, exec, hyprctl dispatch exit"
          "$mod, Print, exec, screenshot"
          "$mod Shift, Print, exec, ${mkScreenshotCmd cfg.bindings.screenshotDir}"

          # Atajos relacionados a las ventanas
          "$mod, Tab, workspace, previous"
          "$mod, k, cyclenext"
          "$mod, k, bringactivetotop"
          "$mod, j, cyclenext, prev"
          "$mod, j, bringactivetotop"
          "$mod, F, fullscreen"
          "$mod, Space, togglefloating"

          # Ejecutar aplicaciones
          "$mod, Return, exec, ${config.apps.terminal}"
          "$mod, v, exec, quickemu --vm $HOME/vm/windows-10.conf"
          "$mod, W, exec, ${config.apps.browser}"
          "$mod CTRL, W, exec, ${cfg.bindings.apps.altBrowser}"
          "$mod, E, exec, thunar"
          "$mod CTRL, E, exec, ${cfg.bindings.apps.terminal} -e hx"
          "$mod, P, exec, ${cfg.bindings.apps.launcher}"
          "$mod SHIFT, P, exec, ${cfg.bindings.apps.imageEditor}"
          "$mod, A, exec, ${cfg.bindings.apps.terminal} -e ${cfg.bindings.apps.mixer}"

          # Manejo de fondos de pantalla
          "$mod, S, exec, rofi-wp"
          "$mod SHIFT, S, exec, random-wp"
          "$mod CTRL, S, exec, setbg"

          # Utilidades del sistema
          "$mod, T, exec, ${config.apps.terminal} -e ts-en"
          "$mod SHIFT, T, exec, ${config.apps.terminal} -e ts-es"
          "$mod, D, exec, ${cfg.bindings.apps.terminal} -e ${cfg.bindings.apps.diskUsage}"
          "$mod SHIFT, D, exec, ${cfg.bindings.apps.terminal} -e ${cfg.bindings.apps.systemMonitor}"

          # Multimedia y comunicacion
          "$mod, X, exec, ${cfg.bindings.apps.gameClient}"
          "$mod SHIFT, X, exec, ${cfg.bindings.apps.gameLauncher}"
          "$mod, B, exec, ${cfg.bindings.apps.terminal} -e ${cfg.bindings.apps.bluetooth}"
          # "$mod, M, exec, ${cfg.bindings.apps.email}"
          # "$mod, M, exec, ${config.apps.music}"
          (
            if config.apps.music == "rmpc" then
              "$mod, M, exec, ${cfg.bindings.apps.terminal} -e ${config.apps.music}"
            else
              "$mod, M, exec, ${config.apps.music}"
          )
        ]
        ++ cfg.bindings.extraBinds
        ++ (
          # Atajos de espacios de trabajo (workspace)
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (
            builtins.genList (
              x:
              let
                ws =
                  let
                    c = (x + 1) / 10;
                  in
                  builtins.toString (x + 1 - (c * 10));
              in
              [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            ) 10
          )
        );

      bindm = [
        # Para el mouse
        # WARNING: No recomiendo quitar esta configuracion
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
    };
  };
}
