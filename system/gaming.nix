{ pkgs, ... }:

{
  imports = [
    # ../package/lutris
  ];

  home.packages = with pkgs; [
    # Games & Launchers
    # clonehero
    # pokemmo-installer
    # prismlauncher
    protontricks
    # (sm64ex.overrideAttrs (attrs: {
    #   makeFlags = attrs.makeFlags ++ [
    #     "BETTERCAMERA=1"
    #   ];
    # }))
    steam
    # steam-run

    # Emulators
    dolphinEmuMaster
    wineWowPackages.staging
    winetricks

    # Recording
    obs-studio
    discord

    # Overlay / Post-processing
    goverlay
    mangohud
    vkBasalt
  ];
}
