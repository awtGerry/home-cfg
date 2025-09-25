{ config, pkgs, ... }:
{

  config = {
    activeProfiles = [
      "development"
      "browsing"
      "gaming"
    ];

    theme = {
      variant = "dark";
      # variant = "light";

      baseScheme = "ayu";
    };

    apps = {
      browser = "firefox";
      terminal = "ghostty";
      launcher = "anyrun";
      editor = "helix";
      music = "rmpc";
    };

    programs.waybar.enable = true;
    wayland.windowManager.hyprland = {
      enable = true;
      visuals = {
        # Agrega reglas de transparencia (testeando con firefox)
        # transparency = {
        #   enable = true;
        #   opacityRules = {
        #     terminal = {
        #       ghostty = "0.90 0.90";
        #     };
        #   };
        # };
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

    home.packages = with pkgs; [
      waydroid
    ];

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
