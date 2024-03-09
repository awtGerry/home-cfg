{ pkgs, config, lib, inputs, ... }:

{
  imports = [
    ./base.nix

    # TODO: Remove for laptos
    ./gaming.nix

    # Web
    ../package/firefox

    # Theme
    ../package/gtk
  ];

  home.username = "gerry";

  home.packages = with pkgs; [
    spotify
    # Utils
    libnotify
    pavucontrol
    dconf
    xcompmgr
    xmenu
    bluez
    bluez-tools
    transmission-gtk

    # Design
    gimp
    figma-linux

    # Documents
    libreoffice
    ffmpeg
    xfce.thunar
    pandoc
    presenterm
    chafa # Image to ASCII

    # Fonts
    fira-code-nerdfont
    font-awesome
    inter
    open-sans
    ostrich-sans
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    source-han-sans
    source-han-sans-japanese
    source-han-serif-japanese
  ];

  # Allow unfree packages
  nixpkgs.config = {
    # allowUnfree = true;
    allowUnfreePredicate = pkg: builtins.elem (builtins.parseDrvName (lib.getName pkg)).name [
      "discord"
      "steam"
      "spotify"
      "steam-original"
      "steam-run"
      "matlab"
      "unrar"
    ];

    permittedInsecurePackages = [
      "openssl-1.1.1v"
    ];
  };

  home.pointerCursor = {
    package = pkgs.gnome.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "23.11";
}
