_:
{
  config,
  lib,
  ...
}:
let
  einkColors = {
    light = {
      # Base colors
      bg = "#fffff8";
      fg = "#1a1a1a";
      bg-alt = "#f5f5ec";
      fg-alt = "#4a4a4a";

      # UI elements
      selection = "#d4d4c8";
      border = "#c8c8bc";
      cursor = "#1a1a1a";
      cursorline = "#f0f0e6";

      # Syntax - subtle but distinguishable
      comment = "#707068";
      keyword = "#2a2a2a";
      string = "#3a3a3a";
      function = "#1a1a1a";
      type = "#2a2a2a";
      constant = "#3a3a3a";
      variable = "#1a1a1a";
      operator = "#4a4a4a";

      # Diagnostics - using weight/style instead of color where possible
      error = "#1a1a1a";
      warning = "#3a3a3a";
      info = "#5a5a5a";
      hint = "#707068";
    };
    dark = {
      # Base colors
      bg = "#121212";
      fg = "#e8e8e0";
      bg-alt = "#1e1e1e";
      fg-alt = "#b0b0a8";

      # UI elements
      selection = "#2e2e2e";
      border = "#3a3a3a";
      cursor = "#e8e8e0";
      cursorline = "#1a1a1a";

      # Syntax - subtle but distinguishable
      comment = "#6a6a62";
      keyword = "#d8d8d0";
      string = "#c0c0b8";
      function = "#e8e8e0";
      type = "#d8d8d0";
      constant = "#c0c0b8";
      variable = "#e8e8e0";
      operator = "#a0a098";

      # Diagnostics
      error = "#e8e8e0";
      warning = "#c0c0b8";
      info = "#9a9a92";
      hint = "#6a6a62";
    };
  };

  colorSchemes = {
    light = {
      nightfox = "dawnfox";
      gruvbox = "gruvbox_light";
      ayu = "ayu_light";
      curzon = "curzon";
    };
    dark = {
      nightfox = "nightfox";
      gruber = "gruber-darker";
      gruvbox = "gruvbox";
      catppuccin = "catppuccin";
      ayu = "ayu_dark";
      curzon = "curzon";
    };
  };

  programOverrides = {
    helix = {
      light = {
        gruvbox = "gruvbox_light";
        nightfox = "dawnfox";
        ayu = "ayu_light";
      };
      dark = {
        gruvbox = "gruvbox_dark_hard";
        nightfox = "nightfox";
        ayu = "ayu_dark";
      };
    };
  };
in
{
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
        "gruvbox"
        "nightfox"
        "e-ink"
        "gruber"
        "catppuccin"
        "curzon"
      ];
      default = "gruvbox";
      description = "Familia de esquema de colores para utilizar";
    };

    scheme = lib.mkOption {
      type = lib.types.str;
      description = "Determinado esquema de colores por tema";
      default =
        if config.theme.baseScheme == "e-ink" then
          "eink_${config.theme.variant}"
        else
          colorSchemes.${config.theme.variant}.${config.theme.baseScheme};
    };

    forProgram = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "Esquema de colores especifico por programa";
      default = lib.mapAttrs (
        program: variants:
        if config.theme.baseScheme == "e-ink" then
          "eink_${config.theme.variant}"
        else
          variants.${config.theme.variant}.${config.theme.baseScheme}
            or colorSchemes.${config.theme.variant}.${config.theme.baseScheme}
      ) programOverrides;
    };

    colors = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "Colores del tema actual";
      default = if config.theme.baseScheme == "e-ink" then einkColors.${config.theme.variant} else { };
    };

    isEink = lib.mkOption {
      type = lib.types.bool;
      description = "Si el tema actual es e-ink";
      default = config.theme.baseScheme == "e-ink";
    };
  };
}
