{ pkgs, config, lib, inputs, ... }:

{
  services.xserver.windowManager = {
    dwm.enable = true;
    dwm.package = pkgs.dwm.overrideAttrs {
      # Dwm testing locally
      src = /home/gerry/Github/suckless_software/dwm;
      # src = pkgs.fetchFromGitHub {
      #   owner = "awtGerry";
      #   repo = "dwm";
      #   rev = "29ebc8cf82e16511538a5946ef13b71dc757f4a5";
      #   sha256 = "sha256-LzNIvLnrBp2IAwAerPa1YO09rff9yNmFyCRx8AWMNl8=";
      # };
    };
  };
}
