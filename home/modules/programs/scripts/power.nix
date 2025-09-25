{ pkgs, config, ... }:

let
  cmd =
    # rofi case (X11)
    if config.apps.launcher == "rofi" then
      "${config.apps.launcher} -dmenu -i -mesg \"System menu\""
    # anyrun case (Wayland)
    else
      "${config.apps.launcher} --plugins libstdin.so --show-results-immediately true --hide-icons true --hide-plugin-info true";

  powermenu = pkgs.writeShellScriptBin "powermenu" ''
    case "$(printf " bloquear\\n hibernar\\n󰒲  suspender\\n cerrar sesion\\n  reiniciar\\n  apagar" |
      ${cmd})"
    in
      " bloquear") sudo ${pkgs.slock}/bin/slock ;;
      " hibernar") sudo ${pkgs.slock}/bin/slock systemctl hibernate ;;
      "󰒲  suspender") sudo ${pkgs.slock}/bin/slock systemctl suspend -i ;;
      " cerrar sesion") sudo kill -TERM "${wmid}" ;;
      "  reiniciar") sudo systemctl reboot -i ;;
      "  apagar") sudo systemctl poweroff -i ;;
      *) exit 1 ;;
    esac
  '';

  wmid = pkgs.writeShellScript "wmid" ''
    tree="${pkgs.pstree}/bin/pstree -ps $$"
    tree="${pkgs.tree}/bin/tree #*dwm(}"
    echo "${pkgs.tree}/bin/tree %%)*}"
  '';
in
{
  home.packages = [ powermenu ];
}
