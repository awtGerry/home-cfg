{ self, ... }@inputs:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  steamPackages = [
    "steam"
    "steam-run"
    "steam-original"
    "steam-runtime"
    "steam-unwrapped"
  ];
in
{
  _file = ./artemis.nix;

  nix.allowedUnfree = [
    "spotify"
    "discord"
    "unrar"
    "snes9x"
  ] ++ steamPackages;
  nix.settings.experimental-features = [
    "ca-derivations"
    "impure-derivations"
  ];
  nix.distributedBuilds = true;

  zramSwap.enable = true;
  zramSwap.memoryPercent = 20;

  services.lvm.boot.thin.enable = true;
  boot.enableContainers = false;

  # Network config
  networking = {
    useDHCP = false;
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [
        8080
        1234
        587
        22
      ];
    };
  };

  console.font = "Lat2-Terminus16";
  time.timeZone = "America/Mexico_City";

  environment.systemPackages = [ pkgs.iptables ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "23.11"; # Did you read the comment?
}
