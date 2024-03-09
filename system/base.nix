{ config, pkgs, ... }:

{
  imports = [
    # Developer stuff
    ./devtools.nix

    # Config pkgs
    ../package/rofi
    ../package/tmux
    ../package/kitty
    ../package/wezterm
    ../package/zsh

    ../package/scripts/default.nix
  ];

  home.packages = with pkgs; [
    # Window manager
    dmenu

    # Core programs
    neovim

    # Network utilities
    curl
    nmap
    whois
    wget

    # Data conversion and manipulation
    fzf
    jq
    unrar
    unzip

    # Search
    bat
    lsd
    lf
    ripgrep
    xclip

    # System utilities
    btop
    neomutt
    neofetch
    maim
    xdotool
    sxiv
    xwallpaper
    zathura

    # System dependencies
    xorg.libX11
    xorg.libX11.dev
    xorg.libxcb
    xorg.libXft
    xorg.libXinerama
    xorg.xinit
    xdg-user-dirs
  ];

}
