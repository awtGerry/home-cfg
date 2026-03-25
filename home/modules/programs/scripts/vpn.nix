{ pkgs, ... }:
let
  vpn = pkgs.writeShellScriptBin "vpn" ''
    usage() {
      echo "Usage: vpn <command>"
      echo "Commands:"
      echo "  us      - Connect to USA (New York)"
      echo "  mx      - Connect to Mexico (fastest)"
      echo "  off     - Disconnect all"
      echo "  status  - Show current VPN status"
    }

    stop_all() {
      sudo systemctl stop openvpn-surfshark-us.service 2>/dev/null
      sudo systemctl stop openvpn-surfshark-mx.service 2>/dev/null
    }

    case "$1" in
      us)
        stop_all
        sudo systemctl start openvpn-surfshark-us.service
        echo "Connected to USA"
        ;;
      mx)
        stop_all
        sudo systemctl start openvpn-surfshark-mx.service
        echo "Connected to Mexico"
        ;;
      off)
        stop_all
        echo "VPN disconnected"
        ;;
      status)
        echo "=== USA ===" 
        sudo systemctl is-active openvpn-surfshark-us.service
        echo "=== Mexico ==="
        sudo systemctl is-active openvpn-surfshark-mx.service
        ;;
      *)
        usage
        ;;
    esac
  '';
in
{
  home.packages = [
    vpn
  ];
}
