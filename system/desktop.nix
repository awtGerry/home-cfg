{ pkgs, ... }:

{
  imports = [
    ../system/base.nix

    # ../package/neovim
    # ../package/kitty
    # ../package/zsh
    # ../package/tmux

    # Utils
    # ../package/git
    # ../package/htop
    # ../package/dunst

    # Mail
    # ../package/neomutt

    # Window manager
    # ../package/dwm

    # Web
    # ../package/firefox
    # ../package/jellyfin

    # Theme
    # ../package/gtk
  ];

  home.packages = with pkgs; [
    # Utils
    zsh
    dmenu
    libnotify
    pavucontrol

    # Network utilities
    curl
    nmap
    whois
    wget

    # System utilities
    htop
    neomutt
    neofetch
    sxiv
    xwallpaper
    zathura

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

    # Design
    gimp
    figma-linux

    # Hob
    spotify

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

  home = {
    pointerCursor = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
  };

  programs.man.enable = true;
}
