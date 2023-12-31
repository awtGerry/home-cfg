{ config, pkgs, ... }:

{
  imports = [
    # Developer stuff
    # ./devtools.nix

    # Config pkgs
    ../package/zsh
    ../package/gtk
  ];

  home.packages = with pkgs; [
    # Window manager
    dwm
    dmenu

    # Core programs
    neovim
    # zsh
    tmux
    kitty
    
    # Web
    firefox

    # Network utilities
    curl
    nmap
    whois
    wget

    # Data conversion and manipulation
    fzf
    jq
    # unrar
    unzip

    # Search
    bat
    lsd
    lf
    ripgrep
    xclip

    # System utilities
    htop
    neomutt
    neofetch
    sxiv
    xwallpaper
    zathura
    xdg-user-dirs

    # System dependencies
    xorg.libX11
    xorg.libX11.dev
    xorg.libxcb
    xorg.libXft
    xorg.libXinerama
    xorg.xinit
  ];

}
