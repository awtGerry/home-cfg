{ pkgs, osConfig, config, ... }:

# let
  # kitty-theme = if config.darkmode then
  #   "Rosé Pine"
  # else
  #   "Rosé Pine Dawn"
  # ;
# in
{
  programs.kitty = {
    enable = true;

    settings = {
      font_family = "Fira Code Nerd Font Mono";
      font_size = if osConfig.networking.hostName == "lyra" then 16 else 13;
      enable_audio_bell = false;
      confirm_os_window_close = 0;
    };

    # theme = kitty-theme;
    theme = "Rosé Pine";
  };
}
