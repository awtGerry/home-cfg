_:{ config, pkgs, lib, ... }:

let
  awtst = pkgs.st.overrideAttrs (oldAttrs: {
    src = pkgs.fetchFromGitHub {
      owner = "awtgerry";
      repo = "vmst";
      rev = "master";
      sha256 = "sha256-HHK0OZ20IQasGEfm6fWVx6qJMhJGMwucUzC3R1GA0OQ=";
    };
    buildInputs = (oldAttrs.buildInputs or []) ++ (with pkgs; [
      xorg.libX11
      xorg.libXft
      xorg.libXinerama
      fontconfig
      freetype
      harfbuzz
    ]);

    nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ (with pkgs; [
      pkg-config
      gnumake
      gcc
    ]);
  });
in
{
  options.programs.awtst.enable = lib.mkEnableOption "ST terminal for VMs";
  config = lib.mkIf config.programs.awtst.enable {
    home.packages = [ awtst ];
  };
}
