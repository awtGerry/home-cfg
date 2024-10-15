{ config, pkgs, ... }:

# TODO: Make a toggler functionality on all the system based on the gtk theme

let
  dark = true;
in
{
  # home.pointerCursor = {
  #   package = pkgs.rose-pine-cursor;
  #   name = "BreezeX-RosePineDawn-Linux";
  #   size = 24;
  #   gtk.enable = true;
  #   x11.enable = true;
  # };

  gtk = {
    enable = true;

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    theme = {
      name = if dark then "WhiteSur-Dark" else "WhiteSur";
      package = pkgs.whitesur-gtk-theme.override { nautilusStyle = "glassy"; };
    };

    iconTheme = {
      package = pkgs.kora-icon-theme;
      name = "kora";
    };

    # TODO: change the font (sf pro maybe)
    font.name = "sans";

    gtk3 = {
      bookmarks = [
        "file://${config.home.homeDirectory}/Documents"
        "file://${config.home.homeDirectory}/Downloads"
        "file://${config.home.homeDirectory}/Music"
        "file://${config.home.homeDirectory}/Pictures"
        "file://${config.home.homeDirectory}/Videos"
        "file://${config.home.homeDirectory}/Dev"
      ];
      extraConfig = {
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintfull";
        gtk-xft-rgba = "rgb";
        # gtk-application-prefer-dark-theme = 1;
        gtk-application-prefer-dark-theme = if dark then 1 else 0;
      };
    };

    gtk2.extraConfig = ''
      gtk-toolbar-style=GTK_TOOLBAR_TEXT
      gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
      gtk-button-images=0
      gtk-menu-images=1
      gtk-enable-event-sounds=1
      gtk-enable-input-feedback-sounds=1
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle="hintfull"
      gtk-xft-rgba="rgb"
    '';

    # gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = if dark then 1 else 0;
  };

  home = {
    sessionVariables = {
      # Use GTK 3 settings in Qt 5
      # https://wiki.archlinux.org/index.php/Uniform_look_for_Qt_and_GTK_applications
      QT_QPA_PLATFORMTHEME = "gtk3";
    };
  };
}
