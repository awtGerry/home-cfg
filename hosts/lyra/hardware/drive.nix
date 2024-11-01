{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
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
    device = "/dev/disk/by-label/Shared";
    fsType = "exfat";
    options = [
      # "rw"
      "allow_other" # for non-root access
      "users" # Allows any user to mount and unmount
      "nofail" # Prevent system from failing if this drive doesn't mountc
    ];
  };

  #swapDevices =
  #  [ { device = "/dev/disk/by-uuid/cca4bde4-ea4c-4901-a794-2905e004f950"; }
  #  ];
}
