{ pkgs, ... }:

{
  imports = [
    ../system/base.nix

    # Window manager
    ../package/dwm

    # Web
    ../package/firefox
    # ../package/jellyfin

    # Theme
    ../package/gtk

    # Other
    ../package/dunst
  ];

  home.packages = with pkgs; [
    # Utils
    dmenu
    libnotify
    pavucontrol

    # Design
    gimp
    figma-linux

    # Chat
    discord

    # Documents
    thunar
    libreoffice
    ffmpeg

    # Fonts
    fira-code-nerdfont
    font-awesome
    inter
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    source-han-sans
    source-han-sans-japanese
    source-han-serif-japanese
  ];

  home = {
    pointerCursor = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
  };
}
