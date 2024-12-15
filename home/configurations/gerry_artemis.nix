{ self, ... }:
{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = {
    nixpkgs.allowedUnfree = [
      "discord"
      "spotify"
    ];

    activeProfiles = [
      "development"
      "gaming"
    ];
    theme.variant = "light";

    wayland.windowManager.hyprland = {
      enable = true;
      visuals = {
        animation.enable = true;
        # Agrega reglas de transparencia (testeando con firefox)
        transparency = {
          enable = true;
          apps = {
            firefox = "0.90 0.90";
          };
        };
      };
    };

    dconf.enable = true;
    systemd.user.tmpfiles.rules = [
      "d ${config.home.homeDirectory}/tmp 700 ${config.home.username} users 14d"
    ];
  };
}
