{ lib, config, ...}:

with lib;

# concept not in use yet

{
  options.opt = {
    theme = mkOption {
      type = str;
      default = "dark";
      description = "The theme to use in the system";
    };
    wallpaper = mkOption {
      type = str;
      # The wallpaper if defined needs to be in the wallpapers folder (~/Pictures/Wallpapers)
      default = if options.opt.theme == "dark" then "mustang.jpg" else "white.png";
      description = "The wallpaper to use in the system";
    };
    language = mkOption {
      type = str;
      default = "en"; # en & es are the only languages supported
      description = "The language to use in the system";
    };
  };

  # options.theme = {
  #   dark = {
  #   };
  #   light = {
  #   };
  # };
}
