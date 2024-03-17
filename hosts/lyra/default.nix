{ pkgs, config, lib, inputs, ... }:

{
  imports = [
    # Hardware
    ../lyra/hardware/default.nix

    # NixOS modules
    inputs.home-manager.nixosModules.default
  ];

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

  services.xserver = {
    enable = true;
    layout = "us";
    videoDrivers = [ "amdgpu" ];
    # Use sddm as the display manager.
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        theme = "${import ../../package/sddm/default.nix { inherit pkgs; }}";
      };
      sessionPackages = [ pkgs.hyprland ];
    };
  };

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

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.11";
}
