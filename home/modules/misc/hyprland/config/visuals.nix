# Configuracion visual para hyprland
# Las reglas son las tablas que reciben hl.window_rule / hl.layer_rule
{ config, lib, ... }:

let
  cfg = config.wayland.windowManager.hyprland;

  # Reglas de opacidad y transparencia
  defaultOpacityRules = {
    terminal = {
      foot = "0.90 0.90";
    };
    apps = {
      lutris = "0.90 0.90";
      steam = "0.80 0.80";
      spotify = "0.80 0.80";
      discord = "0.80 0.80";
      code = "0.80 0.80";
      thunar = "0.80 0.80";
      ghostty = "0.90 0.90";
    };
    system = {
      dunst = "0.90 0.90";
      pavucontrol = "0.80 0.70";
      polkit = "0.80 0.70";
    };
  };

  # Helper function to safely get opacity rules
  getOpacityRules =
    category:
    if cfg.visuals.transparency.opacityRules ? ${category} then
      cfg.visuals.transparency.opacityRules.${category}
    else
      defaultOpacityRules.${category};

  # Helper function to create opacity rules
  makeOpacityRules =
    category:
    lib.mapAttrsToList (name: opacity: {
      match.class = "^(${name})$";
      inherit opacity;
    }) (getOpacityRules category);

  byClass = class: effects: { match.class = class; } // effects;
  byTitle = title: effects: { match.title = title; } // effects;
  floatClass = class: byClass class { float = true; };
  floatTitle = title: byTitle title { float = true; };
  layer = namespace: effects: { match.namespace = namespace; } // effects;
in
{
  imports = [ ]; # Atajos de teclado

  options.wayland.windowManager.hyprland = {
    visuals = {
      blur = lib.mkOption {
        type = with lib.types; attrsOf anything;
        default = {
          size = 6;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
          noise = 0.1;
          contrast = 1.1;
          brightness = 1.2;
          xray = true;
        };
        description = "Activa la configuracion de blur para hyprland";
      };

      animation = {
        enable = lib.mkEnableOption "animations";
        # nombre -> puntos de control de la curva bezier
        beziers = lib.mkOption {
          type = with lib.types; attrsOf (listOf (listOf number));
          default = {
            fluent_decel = [
              [ 0 0.2 ]
              [ 0.4 1 ]
            ];
            easeOutCirc = [
              [ 0 0.55 ]
              [ 0.45 1 ]
            ];
            easeOutCubic = [
              [ 0.33 1 ]
              [ 0.68 1 ]
            ];
            easeinoutsine = [
              [ 0.37 0 ]
              [ 0.63 1 ]
            ];
          };
          description = "Activa animaciones en el sistema";
        };
      };

      transparency = {
        enable = lib.mkEnableOption "Activa la transparencia de las aplicaciones";
        opacityRules = lib.mkOption {
          type = with lib.types; attrsOf (attrsOf str);
          default = defaultOpacityRules;
          description = "Custom opacity rules for different applications";
        };

      };

      # Cada entrada es la tabla de un hl.animation(...)
      rules = lib.mkOption {
        type = with lib.types; listOf (attrsOf anything);
        default =
          map
            (
              a:
              {
                enabled = true;
              }
              // a
            )
            [
              {
                leaf = "windowsIn";
                speed = 1.7;
                bezier = "easeOutCubic";
                style = "slide";
              }
              {
                leaf = "windowsOut";
                speed = 1.7;
                bezier = "easeOutCubic";
                style = "slide";
              }
              {
                leaf = "windowsMove";
                speed = 2.5;
                bezier = "easeinoutsine";
                style = "slide";
              }
              {
                leaf = "fadeIn";
                speed = 3;
                bezier = "easeOutCubic";
              }
              {
                leaf = "fadeOut";
                speed = 3;
                bezier = "easeOutCubic";
              }
              {
                leaf = "fadeSwitch";
                speed = 5;
                bezier = "easeOutCirc";
              }
              {
                leaf = "fadeShadow";
                speed = 5;
                bezier = "easeOutCirc";
              }
              {
                leaf = "fadeDim";
                speed = 6;
                bezier = "fluent_decel";
              }
              {
                leaf = "border";
                speed = 2.7;
                bezier = "easeOutCirc";
              }
              {
                leaf = "workspaces";
                speed = 2;
                bezier = "fluent_decel";
                style = "slide";
              }
              {
                leaf = "specialWorkspace";
                speed = 3;
                bezier = "fluent_decel";
                style = "slidevert";
              }
            ];
        description = "Configuraciones para las animaciones";
      };

      windowRules = {
        workspaceRules = lib.mkOption {
          type = with lib.types; listOf (attrsOf anything);
          default = [
            (byClass "firefox" { workspace = "2"; })
            (byClass "steam" { workspace = "4"; })
            (byClass "lutris" { workspace = "4"; })
            (byClass "gimp" { workspace = "5"; })
            (byClass "discord" { workspace = "8"; })
          ];
          description = "Asignacion de programas en los espacios de trabajo";
        };

        opacityRules = lib.mkOption {
          type = with lib.types; listOf (attrsOf anything);
          default =
            map (class: byClass class { opacity = "0.90 0.90"; }) [
              "^(Ghostty)$"
              "^(${config.apps.terminal})$"
              "^(${config.apps.browser})$"
              "^(foot)$"
              "^(lutris)$"
            ]
            ++ map (class: byClass class { opacity = "0.80 0.80"; }) [
              "^(Steam)$"
              "^(steam)$"
              "^(steamwebhelper)$"
              "^(Spotify)$"
            ]
            ++ map (class: byClass class { opacity = "0.90 0.90"; }) [
              "^(dunst)$"
              "^(Dunst)$"
            ]
            ++ map (class: byClass class { opacity = "0.80 0.80"; }) [
              "^(Code)$"
              "^(thunar)$"
              "^(file-roller)$"
              "^(nwg-look)$"
              "^(qt5ct)$"
              "^(VencordDesktop|Webcord|discord|Discord)"
            ]
            ++ map (class: byClass class { opacity = "0.80 0.70"; }) [
              "^(pavucontrol)$"
              "^(org.kde.polkit-kde-authentication-agent-1)$"
            ]
            ++ map (class: byClass class { opacity = "0.80 0.80"; }) [
              "^(org.telegram.desktop)$"
              "^(code-url-handler)$"
            ]
            ++ map (title: byTitle title { opacity = "0.80 0.80"; }) [
              "^(Spotify( Premium)?)$"
              "^(Spotify( Free)?)$"
              "^(Steam)$"
            ]
            ++ [ (byClass "^(inlyne)$" { opacity = "0.90 0.90"; }) ];
          description = "Transparencia en los programas";
        };

        floatRules = lib.mkOption {
          type = with lib.types; listOf (attrsOf anything);
          default = [
            (floatClass "^(org.kde.polkit-kde-authentication-agent-1)")
            (floatClass "^(pavucontrol)")
            (floatClass "^(zathura)")
            (floatClass "^(thunar)")
            (byClass "^(thunar)" { size = "1280 720"; })
            (floatTitle "^(Media viewer)")
            (floatTitle "^(Volume Control)")
            (floatClass "^(Viewnior)")
            (floatTitle "^(DevTools)")
            (floatClass "^(file_progress)")
            (floatClass "^(confirm)")
            (floatClass "^(dialog)")
            (floatClass "^(download)")
            (floatClass "^(notification)")
            (floatClass "^(error)")
            (floatClass "^(confirmreset)")
            (floatTitle "^(Open File)")
            (floatTitle "^(branchdialog)")
            (floatTitle "^(Confirm to replace files)")
            (floatTitle "^(File Operation Progress)")
            (floatClass "^(com.github.Aylur.ags)")
            (floatTitle "^(Picture-in-Picture)")
          ];
          description = "Programas que se sobreponen (ignora el tipico efecto de un wm)";
        };
      };
      layerrules = lib.mkOption {
        type = with lib.types; listOf (attrsOf anything);
        default = [
          (layer "calendar" { blur = true; })
          (layer "notifications" { blur = true; })
          (layer "notifications" { ignore_alpha = 0.2; })
          (layer "osd" { blur = true; })
          (layer "systemmenu" { blur = true; })
          (layer "anyrun" { blur = true; })
          (layer "popups" { blur = true; })
          (layer "bar" { xray = true; })
          (layer "gtklayershell" { xray = true; })
          (layer "bar" { ignore_alpha = 0.2; })
          (layer "gtklayershell" { ignore_alpha = 0.2; })
          (layer "bar" { ignore_alpha = 0.5; })
          (layer "gtklayershell" { ignore_alpha = 0.5; })
          (layer "music" { ignore_alpha = 0.5; })
        ];
        description = "Programas que se sobreponen (ignora el tipico efecto de un wm)";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      config.decoration = {
        rounding = 1;
        blur = cfg.visuals.blur;
        dim_inactive = true;
        dim_strength = 0.3;
        fullscreen_opacity = 1;
        # shadow = {
        #   enabled = true;
        #   range = 50;
        #   render_power = 3;
        #   color = "rgba(00000055)";
        # };
      };

      curve = lib.mkIf cfg.visuals.animation.enable (
        lib.mapAttrsToList (name: points: {
          _args = [
            name
            {
              type = "bezier";
              inherit points;
            }
          ];
        }) cfg.visuals.animation.beziers
      );
      animation = lib.mkIf cfg.visuals.animation.enable cfg.visuals.rules;

      # dwindle = {
      #   pseudotile = true;
      #   preserve_split = true;
      # };

      # window_rule = cfg.visuals.windowRules.workspaceRules;

      window_rule =
        (lib.optionals cfg.visuals.transparency.enable (
          # Terminal rules
          (makeOpacityRules "terminal")
          ++
            # Apps rules
            (makeOpacityRules "apps")
          ++
            # System rules
            (makeOpacityRules "system")
        ))
        ++ cfg.visuals.windowRules.floatRules;

      layer_rule = cfg.visuals.layerrules;
    };
  };

}
