{ pkgs, config, lib, inputs, ... }:

{
  imports = [
    ./base.nix

    # Web
    ../package/firefox

    # Theme
    ../package/gtk
  ];

  home.username = "gerry";
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    # Utils
    libnotify
    pavucontrol
    dconf

    # Design
    gimp
    figma-linux

    # Documents
    libreoffice
    ffmpeg
    xfce.thunar

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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
