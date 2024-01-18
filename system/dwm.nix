{ pkgs, config, lib, inputs, ... }:

{
  services.xserver.windowManager.dwm.enable = true;
  services.xserver.windowManager.dwm.package = pkgs.dwm.overrideAttrs {
    src = pkgs.fetchFromGitHub {
      owner = "awtGerry";
      repo = "dwm";
      rev = "6b8e0f61a10774bcb132ce911550e392a10537";
      sha256 = "kz2rNeQcOsrewhLEu74ixdFCVhT9drutsaEF+GuvHto=";
    };
  };
}
