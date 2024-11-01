{ self, ... }:
{
  config,
  pkgs,
  lib,
  ...
}:
{
  _file = ./gerry_artemis.nix;

  config = {
    nixpkgs.allowdUnfree = [
      "discord"
      "spotify"
    ];

    activeProfiles = [ "development" ];

    dconf.enable = true;
    systemd.user.tmpfiles.rules = [
      "d ${config.home.homeDirectory}/tmp 700 ${config.home.username} users 14d"
    ];
  };
}
