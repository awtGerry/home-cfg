_:
{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.anyrun;
in
{
  config = lib.mkIf cfg.enable {
    programs.anyrun = {
      # TODO: Crear configuracion para anyrun
      # Configuracion por defecto
      config = {
        x.fraction = 0.5;
        y.fraction = 0.3;
        width.fraction = 0.25;

        hideIcons = false;
        hidePluginInfo = true;
        showResultsImmediately = true;

        ignoreExclusiveZones = false;
        layer = "overlay";
        closeOnClick = false;
        maxEntries = null;

        plugins = [
          "${pkgs.anyrun}/lib/libapplications.so"
          "${pkgs.anyrun}/lib/libsymbols.so"
          "${pkgs.anyrun}/lib/libshell.so"
          "${pkgs.anyrun}/lib/libstdin.so"
        ];
      };

      extraConfigFiles = {
        "applications.ron".text = ''
          Config(
            desktop_actions: false,
            max_entries: 5,
            terminal: Some("${config.apps.terminal}"),
          )
        '';
        "shell.ron".text = ''
          Config(
            prefix: ">",
          )
        '';
      };
    };
  };
}
