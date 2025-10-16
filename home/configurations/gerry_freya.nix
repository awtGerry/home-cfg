{ config, pkgs, ... }:

{
  config = {
    activeProfiles = [
      "development"
      "browsing"
    ];

    theme = {
      variant = "dark";
      baseScheme = "ayu";
    };

    apps = {
      browser = "firefox";
      terminal = "ghostty";
      editor = "helix";
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

    nixpkgs.allowedUnfree = [
      "spotify"
    ];

    home.packages = with pkgs; [
      spotify
      auto-cpufreq
      cpulimit
      xwallpaper
      brightnessctl
    ];
  };
}
