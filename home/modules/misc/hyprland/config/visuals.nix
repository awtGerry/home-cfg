# Configuracion visual para hyprland
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
    lib.mapAttrsToList (name: opacity: "opacity ${opacity},class:^(${name})$") (
      getOpacityRules category
    );
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
          noise = "0.1";
          contrast = "1.1";
          brightness = "1.2";
          xray = true;
        };
        description = "Activa la configuracion de blur para hyprland";
      };

      animation = {
        enable = lib.mkEnableOption "animations";
        beziers = lib.mkOption {
          type = with lib.types; listOf str;
          default = [
            "fluent_decel, 0, 0.2, 0.4, 1"
            "easeOutCirc, 0, 0.55, 0.45, 1"
            "easeOutCubic, 0.33, 1, 0.68, 1"
            "easeinoutsine, 0.37, 0, 0.63, 1"
          ];
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

      rules = lib.mkOption {
        type = with lib.types; listOf str;
        default = [
          "windowsIn, 1, 1.7, easeOutCubic, slide"
          "windowsOut, 1, 1.7, easeOutCubic, slide"
          "windowsMove, 1, 2.5, easeinoutsine, slide"
          "fadeIn, 1, 3, easeOutCubic"
          "fadeOut, 1, 3, easeOutCubic"
          "fadeSwitch, 1, 5, easeOutCirc"
          "fadeShadow, 1, 5, easeOutCirc"
          "fadeDim, 1, 6, fluent_decel"
          "border, 1, 2.7, easeOutCirc"
          "workspaces, 1, 2, fluent_decel, slide"
          "specialWorkspace, 1, 3, fluent_decel, slidevert"
        ];
        description = "Configuraciones para las animaciones";
      };

      windowRules = {
        workspaceRules = lib.mkOption {
          type = with lib.types; listOf str;
          default = [
            "workspace 2, match:class firefox"
            "workspace 4, match:class steam"
            "workspace 4, match:class lutris"
            "workspace 5, match:class gimp"
            "workspace 8, match:class discord"
          ];
          description = "Asignacion de programas en los espacios de trabajo";
        };

        opacityRules = lib.mkOption {
          type = with lib.types; listOf str;
          default = [
            "opacity 0.90 0.90,class:^(Ghostty)$"
            "opacity 0.90 0.90,class:^(${config.apps.terminal})$"
            "opacity 0.90 0.90,class:^(${config.apps.browser})$"
            "opacity 0.90 0.90,class:^(foot)$"
            "opacity 0.90 0.90,class:^(lutris)$"
            "opacity 0.80 0.80,class:^(Steam)$"
            "opacity 0.80 0.80,class:^(steam)$"
            "opacity 0.80 0.80,class:^(steamwebhelper)$"
            "opacity 0.80 0.80,class:^(Spotify)$"
            "opacity 0.90 0.90,class:^(dunst)$"
            "opacity 0.90 0.90,class:^(Dunst)$"
            "opacity 0.80 0.80,class:^(Code)$"
            "opacity 0.80 0.80,class:^(thunar)$"
            "opacity 0.80 0.80,class:^(file-roller)$"
            "opacity 0.80 0.80,class:^(nwg-look)$"
            "opacity 0.80 0.80,class:^(qt5ct)$"
            "opacity 0.80 0.80,class:^(VencordDesktop|Webcord|discord|Discord)"
            "opacity 0.80 0.70,class:^(pavucontrol)$"
            "opacity 0.80 0.70,class:^(org.kde.polkit-kde-authentication-agent-1)$"
            "opacity 0.80 0.80,class:^(org.telegram.desktop)$"
            "opacity 0.80 0.80,class:^(code-url-handler)$"
            "opacity 0.80 0.80,title:^(Spotify( Premium)?)$"
            "opacity 0.80 0.80,title:^(Spotify( Free)?)$"
            "opacity 0.80 0.80,title:^(Steam)$"
            "opacity 0.90 0.90, class:^(inlyne)$"
          ];
          description = "Transparencia en los programas";
        };

        floatRules = lib.mkOption {
          type = with lib.types; listOf str;
          default = [
            "float,class:^(org.kde.polkit-kde-authentication-agent-1)$"
            "float,class:^(pavucontrol)$"
            "float,class:^(zathura)$"
            "float,class:^(thunar)$"
            "size 1280 720, class:^(thunar)$"
            "float,title:^(Media viewer)$"
            "float,title:^(Volume Control)$"
            "float,class:^(Viewnior)$"
            "float,title:^(DevTools)$"
            "float,class:^(file_progress)$"
            "float,class:^(confirm)$"
            "float,class:^(dialog)$"
            "float,class:^(download)$"
            "float,class:^(notification)$"
            "float,class:^(error)$"
            "float,class:^(confirmreset)$"
            "float,title:^(Open File)$"
            "float,title:^(branchdialog)$"
            "float,title:^(Confirm to replace files)$"
            "float,title:^(File Operation Progress)$"
            "float,class:^(com.github.Aylur.ags)$"
            "float, title:^(Picture-in-Picture)$"
          ];
          description = "Programas que se sobreponen (ignora el tipico efecto de un wm)";
        };
      };
      layerrules = lib.mkOption {
        type = with lib.types; listOf str;
        default = [
          "blur on, match:namespace calendar"
          "blur on, match:namespace notifications"
          "blur on, match:namespace osd"
          "blur on, match:namespace systemmenu"
          "blur on, match:namespace anyrun"
          "blur on, match:namespace popups"
          "xray 1, match:namespace bar"
          "xray 1, match:namespace gtklayershell"
          "ignore_alpha 0.2, match:namespace bar"
          "ignore_alpha 0.2, match:namespace gtklayershell"
          "ignore_alpha 0.5, match:namespace bar"
          "ignore_alpha 0.5, match:namespace gtklayershell"
          "ignore_alpha 0.5, match:namespace music"
        ];
        description = "Programas que se sobreponen (ignora el tipico efecto de un wm)";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      decoration = {
        rounding = 1;
        blur = cfg.visuals.blur;
        dim_inactive = true;
        dim_strength = "0.3";
        fullscreen_opacity = 1;
        # drop_shadow = true;
        # shadow_ignore_window = true;
        # shadow_offset = "0 8";
        # shadow_range = 50;
        # shadow_render_power = 3;
        # "col.shadow" = "rgba(00000055)";
        # blurls = [
        #   "lockscreen"
        #   "waybar"
        #   "popups"
        # ];
      };

      animation = lib.mkIf cfg.visuals.animation.enable {
        bezier = cfg.visuals.animation.beziers;
        animation = cfg.visuals.animation.rules;
      };

      dwindle = {
        # no_gaps_when_only = true;
        pseudotile = true;
        preserve_split = true;
      };

      windowrule = cfg.visuals.windowRules.workspaceRules;

      windowrulev2 =
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

      layerrule = cfg.visuals.layerrules;
    };
  };

}
