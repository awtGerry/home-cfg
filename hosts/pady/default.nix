{ pkgs, config, lib, inputs, ... }:

{
  imports = [
    # Hardware
    ../pady/hardware/default.nix

    # NixOS modules
    inputs.home-manager.nixosModules.default
  ];

  networking = {
    hostName = "pady";
    networkmanager.enable = true;
  };

  time.timeZone = "America/Mexico_City";

  # Enable nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gerry = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  programs.neovim = {
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "gerry" = import ../../system/laptop.nix;
    };
  };

  # Set zsh to be default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  services.xserver = {
    enable = true;
    layout = "us";
    displayManager = {
      sddm = {
        enable = true;
        theme = "${import ../../package/sddm/default.nix { inherit pkgs; }}";
      };
      defaultSession = "none+dwm";
      setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xset r rate 300 50
      '';
    };

    windowManager = {
      dwm.enable = true;
      dwm.package = pkgs.dwm.overrideAttrs {
        src = pkgs.fetchFromGitHub {
          owner = "awtGerry";
          repo = "dwm";
          rev = "master";
          sha256 = "sha256-8hy7sQ7vAtHs3iWYi9famLZQMPsfz9Ef9nzkvN4FqgE=";
        };
      };
    };
  };

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
  ];

  environment.sessionVariables = rec {
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";
    XDG_DOWNLOAD_DIR = "$HOME/Downloads";
    XDG_DOCUMENTS_DIR = "$HOME/Documents";
    XDG_MUSIC_DIR = "$HOME/Music";
    XDG_PICTURES_DIR = "$HOME/Pictures";
    XDG_VIDEOS_DIR = "$HOME/Videos";
    XDG_TEMPLATES_DIR = "$HOME/Templates";
    XDG_DESKTOP_DIR = "$HOME/Desktop";
  };

  environment.variables.NIXOS_OZONE_WL = "1";

  # Force all apps to use the same version of mesa as in hardware.opengl.package,
  # regardless of the version it was compiled with
  environment.extraInit = lib.mkIf config.hardware.opengl.enable ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}${lib.makeLibraryPath [
      config.hardware.opengl.package.out
      config.hardware.opengl.package32.out
    ]}
  '';

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.11";
}
