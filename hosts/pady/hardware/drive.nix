{ config, lib, pkgs, modulesPath, ... }:

{
  fileSystems."/" =
    { device = "/dev/disk/by-label/NIXROOT";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };

  swapDevices = [
  	{ 
	device = "/dev/disk/by-uuid/f8804102-0e29-4e17-b4d7-b2ae36d7e1f5";
	}
  ];
}
