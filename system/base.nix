{ pkgs, inputs, ... }:

let
in
{
  imports = [
    ../package/neovim
    ../package/kitty
    ../package/zsh
    ../package/tmux
    # ../package/htop
    ../package/git

    # Mail
    # ../package/neomutt
  ];

  home.packages = with pkgs; [

    # Network utilities
    curl
    nmap
    whois
    wget
    
    # Search
    bat
    lsd
    lf
    ripgrep
    xclip

    # Data conversion and manipulation
    fzf
    jq
    unrar
    unzip

    # System utilities
    htop
    neomutt
    neofetch
    sxiv
    xwallpaper
    zathura

    # Xorg dependencies
    xfce.thunar
    xorg.libX11
    xorg.libX11.dev
    xorg.libxcb
    xorg.libXft
    xorg.libXinerama
    xorg.xinit

  ];

  programs.man.enable = true;
}
