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
      dconf
      maim
      chromium
      auto-cpufreq
      cpulimit

      xcompmgr # Compositor for X

      # Documents
      ffmpeg
      pandoc
      presenterm
      chafa # Image to ASCII
      xwallpaper
      brightnessctl
    ];
  };

  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (builtins.parseDrvName (lib.getName pkg)).name [
      "data.zip"
      "discord"
      "spotify"
      "vvvvvv"
      "unrar"
    ];

    permittedInsecurePackages = [
      "openssl-1.1.1v"
      "nix-2.16.2" # Required by nixd
    ];
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
