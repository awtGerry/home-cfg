_:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.rmpc;
in
{
  config = lib.mkIf cfg.enable {
    programs.rmpc = {
      config = ''
        (
          address: "127.0.0.1:6600",
          password: None,
          theme: None,
          cache_dir: None,
          on_song_change: None,
          volume_step: 5,
          max_fps: 30,
          scrolloff: 0,
          wrap_navigation: false,
          enable_mouse: true,
          enable_config_hot_reload: true,
          browser_song_sort: [Disc, Track, Artist, Title],
        )
      '';
    };

    home.packages = [
      pkgs.picard # Tagging audio
    ];
  };
}
