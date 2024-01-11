{ config, pkgs, ... }:

{
  gtk = {
    enable = true;

    theme = {
      name = "Catppuccin-Macchiato-Compact-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        size = "compact";
        tweaks = [ "rimless" "black" ];
        variant = "macchiato";
      };
    };

    iconTheme = {
      package = pkgs.kora-icon-theme;
      name = "kora";
    };

    # cursorTheme = {
    #   package = pkgs.gnome.adwaita-icon-theme;
    #   name = "Adwaita";
    #   size = 18;
    #
    #   # inherit (config.home.pointerCursor) package name size;
    #   # inherit (config.home.pointerCursor) size;
    # };

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
