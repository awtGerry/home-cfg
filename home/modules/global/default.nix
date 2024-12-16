_:
{
  pkgs,
  lib,
  config,
  ...
}:
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
    # NOTE: La idea de scheme es que sea una derivada de 'variant' (no supe hacerlo de otra forma jeje)
    # Ejemplo:
    # config.theme.variant = "light"
    # config.theme.scheme = if config.theme.variant == "light" then "tu_tema_claro" else "tu_tema_oscuro"
    scheme = lib.mkOption {
      type = lib.types.str;
      default = "nightfox";
      description = "Esquema de colores";
    };
  };

  # Define los programas del usuario
  options.apps = {
    browser = lib.mkOption {
      type = lib.types.str;
      default = "firefox";
      description = "Define el navegador del sistema";
    };

    altBrowser = lib.mkOption {
      enable = lib.mkEnableOption "Activa un navegador secundario";
      type = lib.types.str;
      default = "chromium";
      description = "Define un navegador secundario del sistema";
    };

    terminal = lib.mkOption {
      type = lib.types.str;
      default = "wezterm";
      description = "Define la terminal del sistema";
    };

    editor = lib.mkOption {
      type = lib.types.str;
      default = "helix";
      description = "Define el editor del sistema";
    };
  };
}
