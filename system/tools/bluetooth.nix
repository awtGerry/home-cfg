{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    bluez
    bluez-tools
  ];
}
