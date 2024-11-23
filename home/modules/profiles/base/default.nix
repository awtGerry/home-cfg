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
  dark = if config.theme.variant == "dark" then true else false;
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
      # theme.name = if config.theme.variant == "dark" then "Arc-Dark" else "Arc";
      theme.name = if dark then "Arc-Dark" else "Arc"; # TODO: Ver si funciona para cambiar el resto.

      iconTheme.package = pkgs.kora-icon-theme;
      iconTheme.name = "kora";

      font = {
        name = "SF Pro Display";
        package = self."sf/pro";
      };

      gtk3 = {
        # TODO
        # bookmarks = [
        #   "file://${config.home.homeDirectory}/Documents"
        #   "file://${config.home.homeDirectory}/Downloads"
        #   "file://${config.home.homeDirectory}/Music"
        #   "file://${config.home.homeDirectory}/Pictures"
        #   "file://${config.home.homeDirectory}/Videos"
        #   "file://${config.home.homeDirectory}/Dev"
        # ];
        extraConfig = {
          gtk-xft-antialias = 1;
          gtk-xft-hinting = 1;
          gtk-xft-hintstyle = "hintfull";
          gtk-xft-rgba = "rgb";
          gtk-application-prefer-dark-theme = if config.theme.variant == "dark" then 1 else 0;
        };
      };

      gtk4.extraConfig.gtk-application-prefer-dark-theme =
        if config.theme.variant == "dark" then 1 else 0;
    };

    xsession = {
      enable = true;
      numlock.enable = true;
      # NOTA: Activar esta opcion si se desea usar teclado español por defecto!
      # profileExtra = ''
      #   setxkbmap es
      # '';
    };

    programs = {
      home-manager.enable = true;
      bat.enable = true;
      fzf.enable = true;
      btop.enable = true;

      ssh.enable = true;

      firefox.enable = true;
      helix.enable = true;
    };
  };
}
