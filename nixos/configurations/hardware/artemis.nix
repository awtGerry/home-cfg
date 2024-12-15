{ lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [
    "dm-snapshot"
    "amdgpu"
  ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  # Soporta otros tipos de discos (ejemplo: ntfs & exfat son usados en windows)
  boot.supportedFilesystems = [
    "ntfs"
    "exfat"
    "avfs"
    "xfs"
  ];

  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  # -- DISCOS --
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXBOOT";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  # Disco compartido
  fileSystems."/media/Drive" = {
    device = "/dev/disk/by-label/Shared";
    fsType = "ext4";
    # TODO: Testear esta opcion, en teoria deberia impedir que haya
    #       problemas de arranque.

    options = [ "nofail" ];
  };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  # NOTE: ROCM no esta muy bien implementado todavia, esperemos con el tiempo sea compatible con mi tarjeta.
  # hardware.graphics.extraPackages = with pkgs; [ rocmPackages.clr.icd ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
