{ self, ... }:
{
  config,
  pkgs,
  lib,
  ...
}:
{
  profiles.base.enable = true;
  fonts.fontconfig.enable = true;

  systemd.user = {
    # sessionVariables = { NIX_PATH = nixPath; };
  };

  home = {
    packages = with pkgs; [
      tmate # Comparte terminales

      # Fuentes
      fira-code
      udev-gothic-nf
      noto-fonts-color-emoji
      font-awesome
    ];

    stateVersion = "23.11";
  };
}
