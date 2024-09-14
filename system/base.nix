{ config, lib, pkgs, inputs, ... }:

# This will be called in all machines
{
  imports = [
    # Default tools
    ./tools/devtools.nix
    ./tools/bluetooth.nix
    ./tools/wallpapers.nix
    ./tools/colorscheme.nix

    # Config pkgs
    ../package/cava
    ../package/dunst
    ../package/firefox
    ../package/fzf
    ../package/rofi
    ../package/git
    ../package/gtk
    ../package/lf
    ../package/neofetch
    ../package/tmux
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
    # Core programs
    neovim
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
    imagemagick
    libsixel

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
  ];
}
