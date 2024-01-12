{ lib, pkgs, config, ... }:

{
  users.users.maria = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
    ];
    packages = [ pkgs.home-manager ];
  };
}
