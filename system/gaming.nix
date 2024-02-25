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
    # pokemmo-installer
    # prismlauncher
    protontricks
    # (sm64ex.overrideAttrs (attrs: {
    #   makeFlags = attrs.makeFlags ++ [
    #     "BETTERCAMERA=1"
    #   ];
    # }))
    steam
    steam-run
    # ukmm
    # vvvvvv

    # Emulators
    dolphinEmuMaster
    wineWowPackages.staging
    winetricks

    # Recording
    obs-studio
    discord

    # Overlay / Post-processing
    goverlay
    gamemode
    mangohud
    vkBasalt
  ];
}
