{ config, lib, pkgs, ... }:

# This will be called in all machines
{
  imports = [
    # Default tools
    ./tools/devtools.nix
    ./tools/bluetooth.nix
    ./tools/wallpapers.nix

    # Config pkgs
    ../package/firefox
    ../package/fzf
    ../package/rofi
    ../package/git
    ../package/gtk
    ../package/tmux
    ../package/kitty
    ../package/zathura
    ../package/zsh

    ../package/fonts/default.nix
    ../package/scripts/default.nix
  ];

  # Install all the default packages
  home.packages = with pkgs; [
    # Core programs
    neovim
    xfce.thunar # File manager
    spotify # until i get used to ncmpcpp or spotify tui

    # Network utilities
    curl
    nmap
    whois
    wget

    # Data conversion and manipulation
    jq
    unrar
    unzip

    # Search
    bat
    lsd
    lf
    ripgrep
    xclip

    xcompmgr # Compositor
    # Utils
    libnotify
    pavucontrol
    pulsemixer
    transmission-gtk # Torrent client

    # System utilities
    btop
    neomutt
    neofetch
    maim
    xdotool
    sxiv
    zathura

    # System dependencies
    # xorg.libX11
    # xorg.libX11.dev
    # xorg.libxcb
    # xorg.libXft
    # xorg.libXinerama
    # xorg.xinit
    # xdg-user-dirs 
  ];

}
