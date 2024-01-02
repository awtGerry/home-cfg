{ pkgs, ... }:

{
  imports = [
    # ../package/lutris
  ];

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

  home.packages = with pkgs; [
    # Games & Launchers
    clonehero
    pokemmo-installer
    prismlauncher
    protontricks
    (sm64ex.overrideAttrs (attrs: {
      makeFlags = attrs.makeFlags ++ [
        "BETTERCAMERA=1"
      ];
    }))
    steam
    steam-run

    # Emulators
    dolphinEmuMaster
    wineWowPackages.staging
    winetricks

    # Recording
    obs-studio
    discord

    # Overlay / Post-processing
    goverlay
    mangohud
    vkBasalt
  ];
}
