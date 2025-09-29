{ pkgs, config, ... }:

let
  # Traducir espanol a ingles
  # ts-es = ;
  ts-es = pkgs.writeShellScriptBin "ts-es" ''
    ${pkgs.translate-shell}/bin/trans -b -sl en -tl es --shell
  '';
  # Traducir ingles a espanol
  ts-en = pkgs.writeShellScriptBin "ts-en" ''
    ${pkgs.translate-shell}/bin/trans -b -sl es -tl en --shell
  '';

  launcher =
    # rofi case (X11)
    if config.apps.launcher == "rofi" then
      "${config.apps.launcher} -dmenu -i -mesg \"My notes\""
    # anyrun case (Wayland)
    else
      "${config.apps.launcher} --plugins libstdin.so --show-results-immediately true --hide-icons true --hide-plugin-info true";

  hx-notes = pkgs.writeShellScriptBin "hx-notes" ''
    case "$(printf "New note\\nSync notes\\n$(ls --classic $HOME/Documents/Notes)" | ${launcher})"
    in
      "New note")
        echo "new note"
        ;;
      "Sync notes")
        echo "sync notes"
        ;;
      *)
        xargs -I{} hx{}
        ;;
    esac
  '';
in
{
  home.packages = [
    hx-notes
    # sync-notes
  ];
}
