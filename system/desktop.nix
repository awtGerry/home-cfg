{ config, pkgs, ... }:

{
  home.username = "gerry";
  # home.homeDirectory = "/home/gerry/Github/home-cfg";

  home.stateVersion = "23.11";

  home.packages = [
    # Utils
    # zsh
    # dmenu
    # libnotify
    # pavucontrol
    #
    # # Network utilities
    # curl
    # nmap
    # whois
    # wget
    #
    # # System utilities
    # htop
    # neomutt
    # neofetch
    # sxiv
    # xwallpaper
    # zathura
    #
    # # Data conversion and manipulation
    # fzf
    # jq
    # unrar
    # unzip
    # 
    # # Search
    # bat
    # lsd
    # lf
    # ripgrep
    # xclip
    #
    # # Design
    # gimp
    # figma-linux
    #
    # # Hob
    # spotify
    #
    # # Documents
    # libreoffice
    # ffmpeg
    # xfce.thunar
    #
    # # Fonts
    # fira-code-nerdfont
    # font-awesome
    # inter
    # noto-fonts
    # noto-fonts-cjk
    # noto-fonts-emoji
    # source-han-sans
    # source-han-sans-japanese
    # source-han-serif-japanese

    pkgs.kitty
    pkgs.neovim
    pkgs.firefox
  ];

  # home = {
  #   pointerCursor = {
  #     package = pkgs.gnome.adwaita-icon-theme;
  #     name = "Adwaita";
  #     size = 24;
  #   };
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
