{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  steamPackages = [
    "steam-run"
    "steamcmd"
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
        3000
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

  environment.systemPackages = [
    pkgs.iptables
  ];

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
          sha256 = "sha256-B9qOuL46IfPHQC4YlgGRDD7TpKiSFsJR3+/9Pu9L9Co=";
        };
      };
    };
  };

  # Utiliza `Bloq Mayus.` como `ESC`
  services.interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.caps2esc ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc -m 1 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };

  services.displayManager = {
    sddm = {
      enable = true;
      # TODO: Implementar el tema
      # theme = "${import ../../home/modules/programs/sddm/default.nix { inherit pkgs; }}";
    };
    defaultSession = "none+dwm";
  };

  # Servicios
  programs.dconf.enable = true;
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

  # Activa algunos programas
  programs = {
    zsh.enable = true;
    zsh.enableCompletion = false;
  };

  # Fuerza a las aplicaciones a utilizar la misma version de mesa (si no se activa tauri no funcionaria).
  environment.extraInit = lib.mkIf config.hardware.graphics.enable ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}${
      lib.makeLibraryPath [
        config.hardware.graphics.package.out
        config.hardware.graphics.package32.out
      ]
    }
  '';

  environment = {
    variables.NIXOS_OZONE_WL = "1"; # Permite usar algunos programas que usan wayland
    sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_DOWNLOAD_DIR = "$HOME/Downloads";
      XDG_DOCUMENTS_DIR = "$HOME/Documents";
      XDG_MUSIC_DIR = "$HOME/Music";
      XDG_PICTURES_DIR = "$HOME/Pictures";
      XDG_VIDEOS_DIR = "$HOME/Videos";
      XDG_TEMPLATES_DIR = "$HOME/Templates";
      XDG_DESKTOP_DIR = "$HOME/Desktop";
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "23.11"; # Did you read the comment?
}
