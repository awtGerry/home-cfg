_:
{
  config,
  lib,
  ...
}:
let
  # TODO: Los temas (ej: gruvbox) tienen diferentes nombres en diferentes programas, considerar
  #       hacer un 'diccionario' con los diferentes nombres
  colorSchemes = {
    light = {
      nightfox = "nightfox";
      gruvbox = "gruvbox";
      catppuccin = "catppuccin";
      ayu = "ayu_light";
    };
    dark = {
      nightfox = "nightfox";
      gruvbox = "gruvbox";
      catppuccin = "catppuccin";
      ayu = "ayu_dark";
    };
  };
in
{
  # Elige la variante que se usara en el sistema
  options.theme = {
    variant = lib.mkOption {
      type = lib.types.enum [
        "light"
        "dark"
      ];
      default = "dark";
      description = "Tema global para el sistema (light/dark)";
    };

    baseScheme = lib.mkOption {
      type = lib.types.enum [
        "ayu"
        "catppuccin"
        "gruvbox"
        "nightfox"
      ];
      default = "ayu";
      description = "Familia de esquema de colores para utilizar";
    };

    scheme = lib.mkOption {
      type = lib.types.str;
      description = "Determinado esquema de colores por tema";
      default = colorSchemes.${config.theme.variant}.${config.theme.baseScheme};
    };

    themeAttrs = lib.mkOption {
      type = lib.types.attrs;
      description = "Colores utilizados en las configuracion de programas";
      # ayu defaults
      default = {
        colors = {
          c4 = "#D2A6FF"; # secondary-color
          c3 = "#59C2FF"; # primary-color
          c2 = "#F3F4F5"; # foreground
          c1 = "#3E4B59"; # overlay
          c0 = "#0F1419"; # background
        };
      };
    };
  };
}
