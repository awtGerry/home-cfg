{ pkgs, config, ... }:

# Only for X since in wayland we use wl
let
  rofi_config = "${config.home.configDirectory}/package/rofi/config/left_menu.rasi";
  powermenu = pkgs.writeShellScriptBin "powermenu" ''
    case "$(printf " bloquear"\\n hibernar\\n󰒲 suspender\\n cerrar sesion\\n reiniciar\\n apagar"|
      rofi -dmenu -i -mesg "Screenshot menu" -config ${rofi_config})"
    in
      " bloquear") ${pkgs.slock}/bin/slock ;;
      " hibernar") ${pkgs.slock}/bin/slock systemctl hibernate ;;
      "󰒲 suspender") ${pkgs.slock}/bin/slock systemctl suspend -i ;;
      " cerrar sesion") kill -TERM "${wmid}" ;;
      " reiniciar") systemctl reboot -i ;;
      " apagar") systemctl poweroff -i ;;
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
  # imports = [ ../../system/env.nix ];
  home.packages = [powermenu];
}
