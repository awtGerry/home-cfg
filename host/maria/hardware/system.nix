{ config, lib, pkgs, ... }:

{
  imports = [
    ./autoconfig.nix
    ./drive.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
