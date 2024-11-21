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

    activeProfiles = [ "development" ];
    theme.variant = "light";

    dconf.enable = true;
    systemd.user.tmpfiles.rules = [
      "d ${config.home.homeDirectory}/tmp 700 ${config.home.username} users 14d"
    ];
  };
}
