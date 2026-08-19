_:
{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.anyrun;
  isEinkLight = config.theme.isEink && config.theme.variant == "light";
  colors = config.theme.colors;
in
{
  config = lib.mkIf cfg.enable {
    programs.anyrun = {
      extraCss = lib.mkIf isEinkLight ''
        * {
          color: ${colors.fg};
        }

        #window {
          background: transparent;
        }

        box#main {
          background: rgba(255, 255, 248, 0.95);
          border: 2px solid ${colors.accent};
          border-radius: 10px;
          padding: 8px;
        }

        entry#entry {
          background: ${colors.bg-alt};
          border: 1px solid ${colors.border};
          border-radius: 6px;
          padding: 6px;
          caret-color: ${colors.fg};
        }

        entry#entry:focus {
          border-color: ${colors.fg};
        }

        #match {
          padding: 6px;
          border-radius: 6px;
        }

        #match:selected {
          background: ${colors.selection};
        }

        #plugin label {
          color: ${colors.comment};
        }
      '';

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
