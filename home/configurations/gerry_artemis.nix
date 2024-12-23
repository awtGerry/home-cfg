{ config, ... }:
{

  config = {
    activeProfiles = [
      "development"
      "browsing"
      "gaming"
    ];

    theme = {
      variant = "dark";
      baseScheme = "nightfox";
    };

    apps = {
      browser = "firefox";
      terminal = "kitty";
      # terminal = "ghostty";
      editor = "helix";
    };

    programs.waybar.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      visuals = {
        # animation.enable = true;
        # Agrega reglas de transparencia (testeando con firefox)
        transparency = {
          enable = true;
          opacityRules = {
            terminal = {
              kitty = "0.90 0.90";
            };
            apps = {
              firefox = "0.90 0.90";
            };
          };
        };
      };
      # Atajos de teclado
      # bindings = {
      #   modKey = "SUPER";
      #   # NOTE: Aqui se pueden añadir atajos de teclado adicionales
      #   # extraBinds = [
      #   #   "$mod, C, exec, code"
      #   #   "$mod SHIFT, V, exec, vlc"
      #   # ];
      # };
    };

    home.sessionVariables = {
      # Usa Wayland para aplicaciones Chrome & Electron
      NIXOS_OZONE_WL = 1;
      # Mejora la apariencia de aplicaciones de Java
      JDK_JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel";
    };

    dconf.enable = true;
    systemd.user.tmpfiles.rules = [
      "d ${config.home.homeDirectory}/tmp 700 ${config.home.username} users 14d"
    ];
  };
}
