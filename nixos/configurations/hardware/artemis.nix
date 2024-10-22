{ lib, ... }:
{
  _file = ./artemix.nix;

  imports = [ ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "sr_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.initrd.kernelModules = [
    "dm-snapshot"
    "amdgpu"
  ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [
    "ntfs"
    "exfat"
    "avfs"
    "xfs"
  ];

  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d8136752-a39b-42d1-9b86-a2258d80d615";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/681E-1C3B";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/media/Drive" = {
    device = "/dev/disk/by-uuid/6af823f1-8303-4819-84a0-54143b00b04c";
    fsType = "ext4";
  };

  swapDevices = [ ];

  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # hardware.graphics.extraPackages = with pkgs; [ rocmPackages.clr.icd ];
}
