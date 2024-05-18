{ lib, pkgs, config, ... }:

{
  services.ratbagd = {
    enable = true;
    /* driver = "libratbag";
    devices = [
      {
        name = "Logitech G502";
        driver = "hidpp20";
        id = "046d:c07d";
      }
    ]; */
  };
}
