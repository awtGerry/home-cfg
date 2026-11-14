{ config, lib, ... }:

let
  cfg = config.wayland.windowManager.hyprland;

  # Definir las aplicaciones usadas en el sistema
  # TODO: Mejor variables globales para las aplicaciones? ...
  defaultApps = {
    terminal = config.apps.terminal;
    altBrowser = "chromium";
    editor = config.apps.editor;
    # launcher = config.apps.launcher;
    launcher =
      if config.apps.launcher == "rofi" then
        "${config.apps.launcher} -show drun -show-icons"
      else
        "${config.apps.launcher}";
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

  # hl.bind("<mod> + <teclas>", <dispatcher>[, opts])
  bindWith =
    opts: keys: dispatcher:
    {
      _args = [
        "${cfg.bindings.modKey} + ${keys}"
        (lib.generators.mkLuaInline dispatcher)
      ]
      ++ lib.optional (opts != { }) opts;
    };
  bind = bindWith { };
  exec = keys: cmd: bind keys "hl.dsp.exec_cmd(${lib.generators.toLua { } cmd})";
  terminalExec = keys: cmd: exec keys "${cfg.bindings.apps.terminal} -e ${cmd}";
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
        type = with lib.types; listOf (attrsOf anything);
        default = [ ];
        description = "Atajos adicionales, con la forma `{ _args = [ teclas dispatcher opts? ]; }` de hl.bind";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bind =
      # Atajos del sistema
      [
        (bind "Q" "hl.dsp.window.close()")
        (exec "Backspace" "wlogout")
        (bind "CTRL + Backspace" "hl.dsp.exit()")
        (exec "Print" "screenshot")
        (exec "SHIFT + Print" (mkScreenshotCmd cfg.bindings.screenshotDir))

        # Atajos relacionados a las ventanas
        (bind "Tab" "hl.dsp.focus({ workspace = \"previous\" })")
        (bind "k" "hl.dsp.window.cycle_next()")
        (bind "k" "hl.dsp.window.bring_to_top()")
        (bind "j" "hl.dsp.window.cycle_next({ next = false })")
        (bind "j" "hl.dsp.window.bring_to_top()")
        (bind "F" "hl.dsp.window.fullscreen()")
        (bind "Space" "hl.dsp.window.float({ action = \"toggle\" })")

        # Ejecutar aplicaciones
        (exec "Return" config.apps.terminal)
        (exec "v" "quickemu --vm $HOME/vm/windows-10.conf")
        (exec "W" config.apps.browser)
        (exec "CTRL + W" cfg.bindings.apps.altBrowser)
        (exec "E" "thunar")
        (terminalExec "CTRL + E" "hx")
        (exec "P" cfg.bindings.apps.launcher)
        (exec "SHIFT + P" cfg.bindings.apps.imageEditor)
        (terminalExec "A" cfg.bindings.apps.mixer)
        (exec "N" "hx-notes")

        # Manejo de fondos de pantalla
        (exec "S" "fzf-wp")
        (exec "SHIFT + S" "random-wp")
        (exec "CTRL + S" "setbg")

        # Utilidades del sistema
        (exec "T" "${config.apps.terminal} -e ts-en")
        (exec "SHIFT + T" "${config.apps.terminal} -e ts-es")
        (terminalExec "D" cfg.bindings.apps.diskUsage)
        (terminalExec "SHIFT + D" cfg.bindings.apps.systemMonitor)

        # Multimedia y comunicacion
        (exec "X" cfg.bindings.apps.gameClient)
        (exec "SHIFT + X" cfg.bindings.apps.gameLauncher)
        (terminalExec "B" cfg.bindings.apps.bluetooth)
        # (exec "M" cfg.bindings.apps.email)
        (
          if config.apps.music == "rmpc" then
            terminalExec "M" config.apps.music
          else
            exec "M" config.apps.music
        )

        # Para el mouse
        # WARNING: No recomiendo quitar esta configuracion
        (bindWith { mouse = true; } "mouse:272" "hl.dsp.window.drag()")
        (bindWith { mouse = true; } "mouse:273" "hl.dsp.window.resize()")
        (bindWith { mouse = true; } "ALT + mouse:272" "hl.dsp.window.resize()")
      ]
      ++ cfg.bindings.extraBinds
      ++ (
        # Atajos de espacios de trabajo (workspace)
        # mod + [shift +] {1..9,0} cambia a [mueve la ventana a] la ventana de trabajo {1..10}
        builtins.concatLists (
          builtins.genList (
            x:
            let
              n = toString (x + 1);
              key = toString (lib.mod (x + 1) 10);
            in
            [
              (bind key "hl.dsp.focus({ workspace = ${n} })")
              (bind "SHIFT + ${key}" "hl.dsp.window.move({ workspace = ${n} })")
            ]
          ) 10
        )
      );
  };
}
