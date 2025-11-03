{ pkgs, config, ... }:

let
  launcher =
    # rofi case (X11)
    if config.apps.launcher == "rofi" then
      "${config.apps.launcher} -dmenu -i -mesg \"My notes\""
    # anyrun case (Wayland)
    else
      "${config.apps.launcher} --plugins libstdin.so --show-results-immediately true --hide-icons true --hide-plugin-info true";

  hx-notes = pkgs.writeShellScriptBin "hx-notes" ''
    choice=$(
      printf "New note\\nSync notes\\n$(ls -1 ~/Documents/Notes/*)" | ${launcher}
    )
    case "$choice" in
      "New note")
        echo "new note"
        ;;
      "Sync notes")
        echo "sync notes"
        ;;
      *)
        ${config.apps.terminal} -e hx "$choice"
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
