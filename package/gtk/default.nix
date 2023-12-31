{ config, pkgs, ... }:

{
  gtk = {
    enable = true;

    theme = {
      # package = pkgs.nordic;
      # name = "Nordic-Polar"; # Or "Nordic-Darker" for dark variant
      package = pkgs.arc-theme;
      name = "Arc";
    };

    iconTheme = {
      package = pkgs.arc-icon-theme;
      name = "Arc";
      # package = pkgs.nordic;
      # name = "Nordic-Polar"; # Or "Nordic-Darker" for dark variant
    };

    cursorTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;

      # inherit (config.home.pointerCursor) package name size;

      # inherit (config.home.pointerCursor) size;
    };

    font.name = "sans-serif";

  };
}
