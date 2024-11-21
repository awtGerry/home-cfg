# Elige la variante que se usara en el sistema
{ lib }:
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
  };
}
