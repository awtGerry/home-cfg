{ pkgs, config, lib, inputs, ... }:

{
  imports = [
    # Hardware
    ../lyra/hardware/default.nix

    # Window manager
    ../../system/dwm.nix

    # NixOS modules
    inputs.home-manager.nixosModules.default
  ];

  system.stateVersion = "23.11";

  networking = {
    hostName = "lyra";
    useDHCP = true;
  };

  time.timeZone = "America/Mexico_City";

  # Enable nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gerry = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # run commands in startup
  systemd.user.services.startup = {
    enable = true;
    wantedBy = [ "default.target" ];
    script = ''
      "${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --mode 1920x1080 -r 144"
      "${pkgs.xorg.xset}/bin/xset r rate 300 50"
      "${pkgs.xcompmgr}/bin/xcompmgr"
      "${pkgs.xwallpaper}/bin/xwallpaper --zoom ~/Pictures/bg.png"
    '';
  };

  programs.neovim = {
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "gerry" = import ../../system/desktop.nix;
    };
  };

  # Set zsh to be default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";

    # Use sddm as the display manager.
    displayManager = {
      sddm = {
        enable = true;
        theme = "${import ../../package/sddm/default.nix { inherit pkgs; }}";
      };
      defaultSession = "none+dwm";
      # setupCommands = ''
      #   ${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --mode 1920x1080 -r 144
      #   ${pkgs.xorg.xset}/bin/xset r rate 300 50
      #   ${pkgs.xcompmgr}/bin/xcompmgr
      # '';
    };
  };

  #--=[ NVIDIA settup ]=--#
  nixpkgs.config.nvidia.acceptLicense = true;
  # Enable openGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for xorg
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  };

  environment.systemPackages = with pkgs; [
    spotify
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
  ];

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = pkg: builtins.elem (builtins.parseDrvName (lib.getName pkg)).name [
      "discord"
      "steam"
      "steam-original"
      "steam-run"
      "spotify"
      "joypixels"
      "unrar"
    ];

    permittedInsecurePackages = [
      "openssl-1.1.1v"
    ];
  };
}
