{ lib, pkgs, config, ... }:

{
  users.users.serv = {
    isNormalUser = true;
    # shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "audio"
      "video"

      "rmpgg"
    ];
    packages = [ pkgs.home-manager ];
  };
}
