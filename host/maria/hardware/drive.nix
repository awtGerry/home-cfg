{ config, lib, pkgs, modulesPath, ... }:

{
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/a13b729b-bf7a-425b-b5ba-772a3cc5a14a";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/D70B-965B";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/5eb70bcf-39f7-4caf-992e-dc1e19ced93b";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/cca4bde4-ea4c-4901-a794-2905e004f950"; }
    ];
}
