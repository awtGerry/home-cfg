# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  imports = [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
  ];

  # Enable nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
	    "spotify"
    ];
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1v"
  ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ttpvc"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Mexico_City";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11.
  services.xserver = {
    enable = true;
    layout = "us";

    # Lightdm
    displayManager = {
      lightdm.greeters.enso = {
        enable = true;
      };

      defaultSession = "none+dwm";
      setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --mode 1920x1080 -r 144
      '';
    };

    # Enable dwm
    windowManager = {
      dwm.enable = true;
    };

  };

  # services.xserver.displayManager.setupCommands = ''
  #   ${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --mode 1920x1080 -r 144
  # '';

  # Enable the compositor
  # services.picom.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gerry = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # Enable zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  
  environment.systemPackages = with pkgs; [
    # System
    dmenu
    rofi
	  dwm

    # Dev stuff
    cargo
    rustc
    rustup
	  clang
	  gcc
	  git
    go
    neovim
	  ninja
	  nodejs
    nodePackages.pnpm
    glib
    sqlite
	  openssl
    pkg-config
    perl
    gtk3

    lua-language-server
    rust-analyzer
    gopls
    clang-tools
    # nodePackages.typescript
    nodePackages.typescript-language-server

    # System programs
    firefox
	  kitty
	  neofetch
    lsd
	  zsh
    gimp

    # Basic programs
    spotify
	  ripgrep
    unzip
	  xclip
    tmux
    bat
    lf
    jq
    fzf
    neomutt
    sxiv
    xwallpaper
    zathura

    # Dependencies
    xfce.thunar
    xdg-user-dirs
    xorg.libX11
    xorg.libX11.dev
    xorg.libxcb
    xorg.libXft
    xorg.libXinerama
    xorg.xinit
  ];

  nixpkgs.overlays = [
    (final: prev: {
      dwm = prev.dwm.overrideAttrs (old: { src = ../package/dwm ;});
    })
  ];

  # Fonts
  fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        fira-code-nerdfont
        font-awesome
        noto-fonts
        noto-fonts-emoji
        noto-fonts-cjk
        source-han-sans
        source-han-sans-japanese
        source-han-serif-japanese
      ];

      fontconfig = {
          enable = true;
          defaultFonts = {
              monospace = [ "Fira Code Nerd Font Mono" ];
              serif = [ "Noto Serif" "Source Han Serif" ];
              sansSerif = [ "Noto Sans" "Noto Han Sans" ];
          };
      };
  };

  programs.neovim = {
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}
