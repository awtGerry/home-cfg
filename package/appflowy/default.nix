{ config, pkgs, ... }:

{

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "x-scheme-handler/appflowy-flutter" = [ "appflowy-flutter.desktop" ];
    };
    defaultApplications = {
      "x-scheme-handler/appflowy-flutter" = [ "appflowy-flutter.desktop" ];
    };
  };

  xdg.desktopEntries = {
    appflowy-flutter = {
      name = "Appflowy Flutter";
      exec = "<path/to/appflowy> %U";
      terminal = false;
      categories = [ "Application" ];
      mimeType = [ "x-scheme-handler/appflowy-flutter" ];
    };
  };

  home.packages = [ pkgs.appflowy ];
}
