{ config, pkgs, ... }:

/* TODO: Make a toggler functionality on all the system based on the gtk theme */
let
  dark = "macchiato";
  light = "latte";
in
{
  gtk = {
    enable = true;

    theme = {
      name = "Catppuccin-Macchiato-Compact-Lavender-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "lavender" ];
        size = "compact";
        # tweaks = [ "rimless" "black" ];
        # variant = dark;
        tweaks = [ "rimless" "normal" ];
        variant = light;
      };
    };

    iconTheme = {
      package = pkgs.kora-icon-theme;
      name = "kora";
    };

    cursorTheme = {
      # package = pkgs.catppuccin-cursors.macchiatoDark;
      # name = "Catppuccino-Macchiato-Dark";
      # size = 24;

      inherit (config.home.pointerCursor) package name size;
      # inherit (config.home.pointerCursor) size;
    };

    font.name = "sans";
  };

  home = {
    sessionVariables = {
      # Use GTK 3 settings in Qt 5
      # https://wiki.archlinux.org/index.php/Uniform_look_for_Qt_and_GTK_applications
      QT_QPA_PLATFORMTHEME = "gtk3";
    };
  };
}
