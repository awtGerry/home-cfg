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

      extraCss = with config.theme.themeAttrs.colors; ''
        window {
          background-color: ${c1};
          border: 2px solid ${c1};
        }

        .main {
          margin: 5px;
        }

        text {
          padding: 5px;
          margin: 5px;
          background-color: transparent;
          color: ${c3};
        }

        .matches box.plugin {
          padding: 5px;
        }

        .matches box.plugin .info {
          background-color: ${c1} ;
        }

        .matches box.plugin .info box.horizontal label {
          padding-left: 5px;
        }

        .matches box.plugin list {
          padding: 5px;
        }

        .matches box.plugin list .match .title,
        .matches box.plugin list .match .description {
          padding: 5px;
        }

        .matches box.plugin list .match:selected {
          background-color: ${c2} ;
          color: ${c4} ;
        }

      '';

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
