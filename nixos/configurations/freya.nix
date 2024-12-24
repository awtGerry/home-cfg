{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  # TODO: Habra manera mas ligera de instalar steam?
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
  zramSwap.memoryPercent = 10;

  services.lvm.boot.thin.enable = true;
  boot.enableContainers = false;

  # Configuracion de red
  networking = {
    hostName = "freya";
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

  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      maple-mono-SC-NF
      inputs.self.packages.${pkgs.system}.sf-pro
    ];
  };

  time.timeZone = "America/Mexico_City";

  environment.systemPackages = [ pkgs.iptables ];

  # Xserver
  services.xserver = {
    enable = true;
    xkb.layout = "us";

    windowManager = {
      dwm.enable = true;
      # NOTE: Cambia aqui para usar una configuracion de dwm diferente
      dwm.package = pkgs.dwm.overrideAttrs {
        src = pkgs.fetchFromGitHub {
          owner = "awtGerry";
          repo = "dwm";
          rev = "master";
          # NOTE: Cada que dwm se actualice el sha256 se actualiza con el.
          sha256 = "sha256-2LscNELatqshu59PK3bt8el/TmxUDvTjOIs6Q+rhjps=";
        };
      };
    };
  };

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      # TODO: Implementar el tema
      # theme = "${import ../../home/modules/programs/sddm/default.nix { inherit pkgs; }}";
    };
    # sessionPackages = [ pkgs.hyprland ];
    defaultSession = "none+dwm";
  };

  # Servicios
  services.dbus.packages = [ pkgs.dconf ];
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
  hardware.bluetooth.powerOnBoot = true;

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
  };

  # Activa algunos programas (zsh necesario)
  programs = {
    steam.enable = true;

    zsh.enable = true;
    zsh.enableCompletion = false;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "23.11"; # Did you read the comment?
}
