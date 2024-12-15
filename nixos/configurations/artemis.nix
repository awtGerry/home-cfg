{ self, ... }:
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
    hostName = "artemis";
    # networkmanager.enable = true;

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

  time.timeZone = "America/Mexico_City";

  environment.systemPackages = [ pkgs.iptables ];

  # Xserver
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    videoDrivers = [ "amdgpu" ]; # @necesary
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    # TODO: Implementar el tema
    # theme = "${import ../../home/modules/programs/sddm/default.nix { inherit pkgs; }}";
  };

  services.openssh.enable = true; # OpenSSH daemon
  services.printing.enable = true; # cups

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
  };

  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
  };

  hardware.bluetooth.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
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

  # Activa algunos programas (zsh necesario)
  programs = {
    steam.enable = true;

    zsh.enable = true;
    zsh.enableCompletion = false;
  };

  # Fuerza a usar la misma version de mesa
  environment.extraInit = lib.mkIf config.hardware.graphics.enable ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}${
      lib.makeLibraryPath [
        config.hardware.graphics.package.out
        config.hardware.graphics.package32.out
      ]
    }
  '';

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "23.11"; # Did you read the comment?
}
