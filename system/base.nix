{ config, lib, pkgs, ... }:

# This will be called in all machines
{
  imports = [
    # Default tools
    ./tools/devtools.nix
    ./tools/bluetooth.nix
    ./tools/wallpapers.nix

    # Config pkgs
    ../package/dunst
    ../package/firefox
    ../package/fzf
    ../package/rofi
    ../package/git
    ../package/gtk
    ../package/lf
    ../package/tmux
    ../package/wezterm
    ../package/kitty
    ../package/zathura
    ../package/zsh

    ../package/fonts/default.nix
    ../package/scripts/default.nix
    ../package/latex/default.nix

    ../package/xdg-user-dirs/default.nix
  ];

  # Install all the default packages
  home.packages = with pkgs; [
    # tudus
    # Core programs
    neovim
    helix
    xfce.thunar # File manager

    # Network utilities
    curl
    nmap
    whois
    wget

    # Data conversion and manipulation
    jq
    unrar
    p7zip
    zip
    unzip

    # Search
    bat
    lsd
    ripgrep
    xclip

    # Utils
    libnotify
    pavucontrol
    pulsemixer
    transmission_4-gtk # Torrent client

    # System utilities
    btop
    duf
    neomutt
    neofetch
    lazygit
    # maim # TODO: move maim to x11 dependencies since wayland uses slurp
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
