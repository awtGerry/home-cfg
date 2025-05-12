_:
{ lib, config, ... }:
let
  # TODO: Los temas (ej: gruvbox) tienen diferentes nombres en diferentes programas, ver si
  #       se puede hacer un 'diccionario' con los nombres
  colorSchemes = {
    light = {
      nightfox = "dayfox";
      tokyonight = "tokyonight-day";
      gruvbox = "gruvbox_light";
      catppuccin = "catppuccin";
      rose-pine = "rose_pine";
      gruber-darker = "gruber-darker";
    };
    dark = {
      nightfox = "nightfox";
      tokyonight = "tokyonight";
      gruvbox = "gruvbox";
      catppuccin = "catppuccin";
      rose-pine = "rose_pine";
      gruber-darker = "gruber-darker";
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
        "catppuccin"
        "tokyonight"
        "rose-pine"
        "gruvbox"
        "gruber-darker"
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
      default = "ghostty";
      description = "Terminal del sistema";
    };
    editor = lib.mkOption {
      type = lib.types.str;
      default = "helix";
      description = "Editor principal";
    };
    launcher = lib.mkOption {
      type = lib.types.str;
      default = "rofi";
      description = "Launcher";
    };
  };

  options.dirs = {
    # Directorio de este repositorio
    # (se utiliza en algunas configuraciones hasta que consiga una mejor manera)
    repoDir = lib.mkOption {
      type = lib.types.path;
      default = "${config.home.homeDirectory}/Dev/public/home-cfg";
    };
    publicRepos = lib.mkOption {
      type = lib.types.path;
      default = "${config.home.homeDirectory}/Dev/public/";
    };
    privateRepos = lib.mkOption {
      type = lib.types.path;
      default = "${config.home.homeDirectory}/Dev/private/";
    };
  };
}
