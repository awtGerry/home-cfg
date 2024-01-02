{ config, lib, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
      ../system/hardware-configuration.nix
  ];
  time.timeZone = "America/Mexico_City";

  # Enable nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable X11 and display manager.
  services.xserver = {
    enable = true;
    layout = "us";

    # Lightdm
    displayManager = {
      lightdm.greeters.enso = {
        enable = true;
      };

      defaultSession = "none+dwm";
      setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --mode 1920x1080 -r 144
      '';
    };

    # Enable dwm
    windowManager = {
      dwm.enable = true;
    };

  };

  nixpkgs.overlays = [
    (final: prev: {
      dwm = prev.dwm.overrideAttrs (old: { src = ../package/dwm ;});
    })
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gerry = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  home.packages = with pkgs; [
    # Xorg dependencies
    xorg.libX11
    xorg.libX11.dev
    xorg.libxcb
    xorg.libXft
    xorg.libXinerama
    xorg.xinit

  ];
}
