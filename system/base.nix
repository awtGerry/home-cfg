{ lib, config, pkgs, ... }:

# Basic configuration for nixos to get up and running.

{
  imports = [
    ../system/hardware-configuration.nix
  ];

  # Define your hostname.
  networking.hostName = "awtnix";

  time.timeZone = "America/Mexico_City";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Nvidia config
  nixpkgs.config.nvidia.acceptLicense = true;
  # Enable openGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for xorg
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  };

  # Enable x11
  services.xserver = {
    enable = true;
    layout = "us";

    # Lightdm
    displayManager = {
      lightdm.greeters.enso = {
        enable = true;
      };

      # Set dwm to be the default session
      defaultSession = "none+dwm";
      setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --mode 1920x1080 -r 144
        xset r rate 300 50
      '';
    };

    # Enable dwm
    windowManager = {
      dwm.enable = true;
    };
  };
}
