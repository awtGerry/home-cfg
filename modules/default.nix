{ lib, config, ...}:

with lib;

{
  options.useropt = {
    theme = mkOption {
      type = str;
      default = "dark";
      description = "The theme to use in the system";
    };
    wallpaper = mkOption {
      type = str;
      default = if options.useropt.theme == "dark" then "dark-wallpaper" else "light-wallpaper";
      description = "The wallpaper to use in the system";
    };
  };

  options.theme = {
    dark = {
    };
    light = {
    };
  };
}
