{ self, ... }:
{
  config,
  pkgs,
  lib,
  ...
}:
{
  activeProfiles = [
    "development"
    "browsing"
    "gaming"
  ];
  theme.variant = "dark";

  home.packages = with pkgs; [
    # Wayland packages
    xwayland
    xwaylandvideobridge
    wl-clipboard
    wlr-randr
    slurp
    grim
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    visuals = {
      # animation.enable = true;
      # Agrega reglas de transparencia (testeando con firefox)
      transparency = {
        opacityRules = {
          apps = {
            firefox = "0.90 0.90";
          };
        };
      };
    };
    # Atajos de teclado
    bindings = {
      modKey = "SUPER";
      # apps = {
      #   terminal = "ghostty";
      # };
      # NOTE: Aqui se pueden añadir atajos de teclado adicionales
      # extraBinds = [
      #   "$mod, C, exec, code"
      #   "$mod SHIFT, V, exec, vlc"
      # ];
    };
  };

  sessionVariables = {
    # Use Wayland for Chrome & Electron apps
    NIXOS_OZONE_WL = 1;

    # Improve appearance of Java applications
    # https://wiki.archlinux.org/index.php/Java#Tips_and_tricks
    JDK_JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel";
  };

  dconf.enable = true;
  systemd.user.tmpfiles.rules = [
    "d ${config.home.homeDirectory}/tmp 700 ${config.home.username} users 14d"
  ];
}
