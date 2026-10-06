# Centralized agent host: SSH (key-only) + Tailscale + idle power tuning
# + freeze protection when agents run out of memory.
# See docs/adr/0001-centralized-agent-host.md for the rationale and
# docs/agent-host.md for the setup/daily-use runbook.
_:
{ config, lib, ... }:

let
  cfg = config.awt.server;
in
{
  options.awt.server = {
    enable = lib.mkEnableOption "centralized agent host (SSH + Tailscale + power tuning)";

    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "ssh-ed25519 AAAA... gerry@work-wsl-artemis" ];
      description = "Claves publicas SSH permitidas para el usuario gerry";
    };
  };

  config = lib.mkIf cfg.enable {
    # SSH endurecido: solo llaves, sin root.
    # OJO: con PasswordAuthentication desactivado y authorizedKeys vacio,
    # el acceso remoto queda cerrado hasta agregar una llave (fail-closed).
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    users.users.gerry.openssh.authorizedKeys.keys = cfg.authorizedKeys;

    # Tailscale: el primer registro es manual (`sudo tailscale up`),
    # la llave del nodo persiste en /var/lib/tailscale.
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "none";
      extraUpFlags = [ "--accept-dns=true" ];
    };
    networking.firewall.trustedInterfaces = [ "tailscale0" ];

    # Que los procesos de usuario (tmux incluido) sobrevivan al cierre
    # de la sesion grafica.
    users.users.gerry.linger = true;

    # Ahorro de energia en idle (la maquina nunca se suspende).
    # NO usar powerManagement.powertop: su auto-tune suspende los USB
    # y el teclado/raton tardan segundos en despertar.
    # El EPP hace el trabajo importante en el CPU de todas formas.

    # EPP de AMD en balance_power: baja agresivamente en idle pero
    # responde al instante al compilar. No hace nada si amd_pstate
    # no esta activo (ConditionPathExistsGlob).
    systemd.services.amd-epp-balance-power = {
      description = "Set AMD energy performance preference to balance_power";
      wantedBy = [ "multi-user.target" ];
      after = [ "sysinit.target" ];
      unitConfig.ConditionPathExistsGlob =
        "/sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference";
      serviceConfig.Type = "oneshot";
      script = ''
        for f in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
          [ -w "$f" ] && echo balance_power > "$f"
        done
      '';
    };

    # Varios agentes enlazando a la vez (`ld` de +1GB cada uno) agotan la RAM.
    # El OOM killer del kernel llega tarde: la maquina se queda paginando
    # minutos sin responder, y cuando actua puede matar al systemd del
    # usuario (y con el a todas las sesiones de tmux). earlyoom actua antes
    # y elige al enlazador/compilador. El tope de memoria de los agentes
    # vive en home-manager (agents.memoryCap).
    # `[.]` y `[[:space:]]` en vez de `\.` y ` `: los argumentos pasan por el
    # ExecStart de systemd, que los parte en espacios y trata las barras
    # invertidas a su manera. Los nombres son el `comm` del proceso
    # (tmux se renombra a "tmux: server").
    services.earlyoom = {
      enable = true;
      extraArgs = [
        "--prefer"
        "^(ld([.](bfd|gold|lld))?|mold|collect2|cc1(plus)?|rustc)$"
        "--avoid"
        "^(systemd|[.]?Hyprland(-wrapp)?|sddm|sshd(-session)?|tmux(:[[:space:]](server|client))?|pipewire|wireplumber|Xwayland)$"
      ];
    };

    # Magic SysRq por si aun asi se congela: Alt+ImprPant+F mata el proceso
    # mas grande, Alt+ImprPant+R,E,I,S,U,B reinicia sin desconectar.
    # 244 = teclado (4) + sync (16) + remount (32) + senales (64) + reboot (128).
    boot.kernel.sysctl."kernel.sysrq" = 244;
  };
}
