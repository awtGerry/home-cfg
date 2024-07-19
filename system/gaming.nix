{ inputs, config, pkgs, ... }:

{
  imports = [
    ../package/lutris
  ];

  home.packages = with pkgs; [
    xpad
    xboxdrv

    # Games & Launchers
    # clonehero
    prismlauncher
    protontricks
    eww
    ukmm
    vvvvvv
    steam
    steam-run
    heroic

    # Emulators
    dolphinEmuMaster
    wineWowPackages.staging
    winetricks
    ryujinx

    discord

    # Overlay / Post-processing
    goverlay
    gamemode
    gamescope
    mangohud
    vkBasalt

    # Game dependencies
    xorg.libXtst
    xorg.libXrender
    xorg.libXext
  ];

}
