{ pkgs, config, lib, inputs, ... }:

{
  imports = [
    ./base.nix
    ../package/thunderbird
  ];

  home.username = "gerry";

  home = {
    packages = with pkgs; [
      spotify
      inter

      # Documents
      ffmpeg
      pandoc
      presenterm
      chafa # Image to ASCII
    ];

    pointerCursor = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };

  };

  # Laptop will use dwm
  services.xserver.windowManager = {
    dwm.enable = true;
    dwm.package = pkgs.dwm.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "awtGerry";
        repo = "dwm";
        rev = "29ebc8cf82e16511538a5946ef13b71dc757f4a5";
        sha256 = "sha256-LzNIvLnrBp2IAwAerPa1YO09rff9yNmFyCRx8AWMNl8=";
      };
    };
  };
}
