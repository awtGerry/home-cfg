{ config, pkgs, ... }: 

{
  imports = [
    ./visuals.nix
    ./keybinds.nix
  ];
}
