{ lib, ... }:
{
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

  # Shared disk for w10 and nixos
  fileSystems."/media/Drive" = {
    device = "/dev/disk/by-label/Unix";
    fsType = "exfat";
  };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # hardware.graphics.extraPackages = with pkgs; [ rocmPackages.clr.icd ];
}
