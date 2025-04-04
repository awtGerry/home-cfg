{
  config,
  pkgs,
  inputs,
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
    packages = [
      # maple-mono-SC-NF
      inputs.self.packages.${pkgs.system}.sf-pro
    ];
  };

  time.timeZone = "America/Mexico_City";

  environment.systemPackages = [
    pkgs.iptables
    pkgs.libsForQt5.qt5.qtwebengine
    # Para virtualizacion
    pkgs.qemu
    pkgs.quickemu
    pkgs.quickgui
    (pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
      qemu-system-x86_64 \
        -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
        "$@"
    '')
  ];

  # Xserver
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    videoDrivers = [ "amdgpu" ]; # @necesary
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
      wayland.enable = true;
      # TODO: Implementar el tema
      # theme = "${import ../../home/modules/programs/sddm/default.nix { inherit pkgs; }}";
    };
    sessionPackages = [ pkgs.hyprland ];
  };

  services.dbus.packages = [ pkgs.dconf ];
  services.openssh.enable = true; # OpenSSH daemon
  services.printing.enable = true; # cups

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;

    # Arregla problemas de audio en algunos juegos
    extraConfig.pipewire."99-custom" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 256;
        "default.clock.min-quantum" = 256;
        "default.clock.max-quantum" = 2048;
      };
      "context.modules" = [
        {
          name = "libpipewire-module-rtkit";
          args = {
            "nice.level" = -15;
            "rt.prio" = 88;
            "rt.time.soft" = 200000;
            "rt.time.hard" = 200000;
          };
          flags = [
            "ifexists"
            "nofail"
          ];
        }
      ];
    };

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
    waydroid.enable = true; # Emulador android para wayland
    docker.enable = true;
    containers.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

  # users.groups.libvirtd.members = [ "gerry" ];

  users.users = {
    gerry = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "wheel"
        "docker"
        "audio"
        "networkmanager"
        "libvirtd"
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
    # virt-manager.enable = true;

    # Arregla algunos problemas con helix y tmux
    screen = {
      enable = true;
      screenrc = ''
        maptimeout 0
      '';
    };

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
