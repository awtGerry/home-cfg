{ lib, pkgs, config, ... }:

{
  users.users.gerry = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
    ];
    packages = [ pkgs.home-manager ];
  };
}
