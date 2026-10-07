# Tope de memoria compartido para los agentes que corren en tmux.
# El servidor de tmux arranca por activacion de socket dentro de
# agents.slice, y tmux crea el scope de cada panel en el slice del servidor:
# todos los agentes (y sus `ld`) comparten el tope. Si lo rebasan, el kernel
# mata al proceso mas grande dentro del slice y el resto del sistema
# (Hyprland, navegador, sshd) ni se entera. Ver docs/agent-host.md.
_:
{ config, lib, ... }:
let
  cfg = config.agents.memoryCap;
  tmux = config.programs.tmux;
  # La misma ruta que usan los clientes (TMUX_TMPDIR con secureSocket)
  socket = "${if tmux.secureSocket then "%t" else "/tmp"}/tmux-%U/default";
in
{
  options.agents.memoryCap = {
    enable = lib.mkEnableOption "tope de memoria compartido para los agentes en tmux";

    max = lib.mkOption {
      type = lib.types.str;
      default = "10G";
      description = "Tope duro: al rebasarlo el kernel mata al proceso mas grande del slice (MemoryMax)";
    };
  };

  config = lib.mkIf cfg.enable {
    # Sin MemoryHigh a proposito: por encima de el el kernel frena a todo el
    # slice y un `ld` desbocado se arrastra minutos en vez de morir, con lo
    # que todos los agentes parecen colgados. Mejor que muera rapido y el
    # agente lo vea (exit 137) y reintente.
    systemd.user.slices.agents = {
      Unit.Description = "Agentes en tmux con tope de memoria";
      Slice.MemoryMax = cfg.max;
    };

    systemd.user.sockets.tmux = {
      Unit = {
        Description = "Socket del servidor de tmux";
        # No robarle el socket a un servidor que ya este corriendo: sus
        # sesiones seguirian vivas pero quedarian inalcanzables.
        ConditionPathExists = "!${socket}";
      };
      Socket = {
        ListenStream = socket;
        SocketMode = "0600";
        # tmux rechaza el directorio si tiene permisos de grupo/otros
        DirectoryMode = "0700";
      };
      Install.WantedBy = [ "sockets.target" ];
    };

    systemd.user.services.tmux = {
      Unit = {
        Description = "Servidor de tmux (dentro de agents.slice)";
        # Reiniciarlo mataria todos los paneles, y con ellos a los agentes
        X-SwitchMethod = "keep-old";
      };
      Service = {
        Slice = "agents.slice";
        # -D: sin daemonizar y con exit-empty apagado
        ExecStart = "${tmux.package}/bin/tmux -D";
      };
    };

    # Por defecto systemd detiene el scope entero cuando el kernel mata a uno
    # de sus procesos: un `ld` muerto se llevaria al agente de ese panel.
    xdg.configFile."systemd/user/tmux-spawn-.scope.d/oom-policy.conf".text = ''
      [Scope]
      OOMPolicy=continue
    '';
  };
}
