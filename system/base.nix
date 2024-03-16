{ config, pkgs, ... }:

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
    ../package/tmux
    ../package/wezterm
    ../package/zathura
    ../package/zsh

    ../package/fonts/default.nix
    ../package/scripts/default.nix
  ];

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "openssl-1.1.1v"
    ];
  };

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
    unzip

    # Search
    bat
    lsd
    lf
    ripgrep
    xclip

    # Utils
    libnotify
    pavucontrol
    pulsemixer
    xcompmgr # Compositor
    transmission # Torrent client

    # System utilities
    btop
    neomutt
    neofetch
    maim
    xdotool
    sxiv
    xwallpaper
    zathura
  ];

}
