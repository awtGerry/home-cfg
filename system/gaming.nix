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
    snes9x

    # Recording
    obs-studio
    discord

    # Overlay / Post-processing
    goverlay
    gamemode
    gamescope
    mangohud
    vkBasalt
  ];

  # Better driver for Xbox One controllers
  # hardware.xpadneo.enable = true;

  # Enable GameMode to optimise system performance on-demand
  /* programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };

      custom = {
        start = "${pkgs.libnotify}/bin/notify-send --app-name GameMode 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send --app-name GameMode 'GameMode ended'";
      };
    };
  }; */

}
