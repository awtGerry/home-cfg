{ config, lib, pkgs, modulesPath, ... }:

{
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/d8136752-a39b-42d1-9b86-a2258d80d615";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/681E-1C3B";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/media/Drive" =
    { device = "/dev/disk/by-uuid/6af823f1-8303-4819-84a0-54143b00b04c";
      fsType = "ext4";
    };

  #swapDevices =
  #  [ { device = "/dev/disk/by-uuid/cca4bde4-ea4c-4901-a794-2905e004f950"; }
  #  ];
}
