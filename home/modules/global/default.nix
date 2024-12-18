_:
{ lib, config, ... }:
let
  colorSchemes = {
    light = {
      nightfox = "nightfox"; # No me gusta 'dayfox'
      tokyonight = "tokyonight-day";
      gruvbox = "gruvbox_light";
    };
    dark = {
      nightfox = "nightfox";
      tokyonight = "tokyonight-night";
      gruvbox = "gruvbox-dark_hard";
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
        "nightfox"
        "tokyonight"
        "gruvbox"
      ];
      default = "nightfox";
      description = "Familia de esquema de colores para utilizar";
    };

    scheme = lib.mkOption {
      type = lib.types.str;
      description = "Determinado esquema de colores por tema";
      default = colorSchemes.${config.theme.variant}.${config.theme.baseScheme};
    };
  };

  options.apps = {
    browser = lib.mkOption {
      type = lib.types.str;
      default = "firefox";
      description = "Navegador principal";
    };
    terminal = lib.mkOption {
      type = lib.types.str;
      default = "wezterm";
      description = "Terminal del sistema";
    };
    editor = lib.mkOption {
      type = lib.types.str;
      default = "helix";
      description = "Editor principal";
    };
  };
}
