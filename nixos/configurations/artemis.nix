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
        443
        80
        587
        22
        9002
        9003
      ];
    };
  };

  console.font = "Lat2-Terminus16";
  time.timeZone = "America/Mexico_City";

  environment.systemPackages = [ pkgs.iptables ];

  # Services
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    videoDrivers = [ "amdgpu" ];
  };

  services.displayManager.sddm = {
    enable = true;
    # theme = "${import ../../package/sddm/default.nix { inherit pkgs; }}";
  };
  services.displayManager.defaultSession = "none+dwm";

  services.openssh.enable = true; # Enable OpenSSH daemon
  services.printing.enable = true; # Enable cups

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "23.11"; # Did you read the comment?
}
