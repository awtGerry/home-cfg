{ pkgs, config, lib, inputs, ... }:

{
  imports = [
    ./autoconfig.nix
    ./drive.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  # Enable pipewire (sound & video)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
}
