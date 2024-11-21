# Todos los perfiles comparten esta configuracion

# Home manager configuracion base:
{ self, nix, ... }:

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.base;
in
{
  options.profiles.base = {
    enable = lib.mkEnableOption "Perfil base, siempre activo";
  };

  config = lib.mkIf cfg.enable {
    # Configuracion de GTK
    gtk = {
      enable = true;

      theme.package = pkgs.arc-theme;
      theme.name = if config.theme.variant == "dark" then "Arc-Dark" else "Arc";

      iconTheme.package = pkgs.kora-icon-theme;
      iconTheme.name = "kora";

      font = {
        name = "SF Pro Display";
        package = self."sf/pro";
      };
    };
  };
}
