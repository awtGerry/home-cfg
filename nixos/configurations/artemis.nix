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
  nix.allowedUnfree = [ "unrar" ] ++ steamPackages;
  nix.settings.experimental-features = [
    "ca-derivations"
    "impure-derivations"
  ];
  nix.distributedBuilds = true;

  zramSwap.enable = true;
  zramSwap.memoryPercent = 20;

  services.lvm.boot.thin.enable = true;
  boot.enableContainers = false;

  # Configuracion de red
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

  # Servicios
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    videoDrivers = [ "amdgpu" ];
  };

  services.displayManager.sddm = {
    enable = true;
    # TODO: Implement theme
    # theme = "${import ../../package/sddm/default.nix { inherit pkgs; }}";
  };
  services.displayManager.defaultSession = "none+dwm";

  services.openssh.enable = true; # OpenSSH daemon
  services.printing.enable = true; # cups

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;

  hardware.graphics.enable = true;
  # hardware.graphics.extraPackages = with pkgs; [ rocmPackages.clr.icd ]; # No funciona para 5000 cards.

  virtualisation = {
    docker.enable = true;
    containers.enable = true;
    libvirtd.enable = true;
  };

  users.users = {
    gerry = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "wheel"
        "docker"
        "audio"
        "networkmanager"
      ];
    };
    gamer = {
      isNormalUser = true;
      extraGroups = [
        "audio"
        "networkmanager"
      ];
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "23.11"; # Did you read the comment?
}
