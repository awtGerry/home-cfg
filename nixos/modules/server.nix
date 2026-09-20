# Centralized agent host: SSH (key-only) + Tailscale + idle power tuning.
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
  };
}
