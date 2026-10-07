# Pruebas de evaluacion de las configuraciones.
# Correr con: nix build .#checks.x86_64-linux.agent-memory-guard
{ self, lib, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    {
      checks = lib.optionalAttrs (system == "x86_64-linux") {
        # Que un `ld` de algun agente no congele artemis (ver docs/agent-host.md)
        agent-memory-guard =
          let
            nixos = self.nixosConfigurations.artemis.config;
            home = self.homeConfigurations."gerry@artemis".config;
            user = home.systemd.user;

            # Valor que sigue a `flag` en los argumentos de earlyoom
            earlyoomArg =
              flag:
              let
                args = nixos.services.earlyoom.extraArgs;
                i = lib.lists.findFirstIndex (a: a == flag) null args;
              in
              if i == null then null else builtins.elemAt args (i + 1);
            # earlyoom compara la regex contra el nombre del proceso (comm)
            matches = regex: name: regex != null && builtins.match regex name != null;

            sysrq = nixos.boot.kernel.sysctl."kernel.sysrq" or 0;
            sysrqAllows = bit: builtins.bitAnd sysrq bit != 0;

            failures = lib.runTests {
              testEarlyoomEnabled = {
                expr = nixos.services.earlyoom.enable;
                expected = true;
              };
              testEarlyoomPrefersLinkersAndCompilers = {
                expr = map (matches (earlyoomArg "--prefer")) [
                  "ld"
                  "ld.lld"
                  "mold"
                  "collect2"
                  "cc1plus"
                  "rustc"
                  ".claude-wrapped"
                ];
                expected = [
                  true
                  true
                  true
                  true
                  true
                  true
                  false
                ];
              };
              testEarlyoomAvoidsSessionProcesses = {
                expr = map (matches (earlyoomArg "--avoid")) [
                  "systemd"
                  ".Hyprland-wrapp"
                  "sshd-session"
                  "tmux: server"
                  "tmux: client"
                  "pipewire"
                  "ld"
                ];
                expected = [
                  true
                  true
                  true
                  true
                  true
                  true
                  false
                ];
              };
              # Alt+ImprPant+F: el kernel mata el proceso mas grande
              testSysrqAllowsOomKill = {
                expr = sysrqAllows 64;
                expected = true;
              };
              # Alt+ImprPant+R,E,I,S,U,B: reinicio seguro en vez de desconectar
              testSysrqAllowsReisub = {
                expr = map sysrqAllows [
                  4
                  16
                  32
                  64
                  128
                ];
                expected = [
                  true
                  true
                  true
                  true
                  true
                ];
              };

              # Solo tope duro: con MemoryHigh el kernel frena a todo el slice
              # y un `ld` desbocado se arrastra en vez de morir (los agentes
              # parecen colgados).
              testAgentsSliceIsCapped = {
                expr = user.slices.agents.Slice or null;
                expected = {
                  MemoryMax = "10G";
                };
              };
              # tmux crea el scope de cada panel en el slice del servidor
              testTmuxServerRunsInAgentsSlice = {
                expr = user.services.tmux.Service.Slice or null;
                expected = "agents.slice";
              };
              testTmuxServerIsTheHomeManagerTmux = {
                expr = user.services.tmux.Service.ExecStart or null;
                expected = [ "${home.programs.tmux.package}/bin/tmux -D" ];
              };
              # Reiniciar el servidor al hacer switch mataria a los agentes
              testSwitchKeepsTmuxRunning = {
                expr = user.services.tmux.Unit.X-SwitchMethod or null;
                expected = "keep-old";
              };
              # Debe ser la misma ruta que usan los clientes (TMUX_TMPDIR)
              testTmuxSocketMatchesClientPath = {
                expr = user.sockets.tmux.Socket.ListenStream or null;
                expected = "%t/tmux-%U/default";
              };
              # tmux rechaza el directorio si tiene permisos de grupo/otros
              testTmuxSocketDirIsPrivate = {
                expr = user.sockets.tmux.Socket.DirectoryMode or null;
                expected = "0700";
              };
              testTmuxSocketDoesNotStealRunningServer = {
                expr = user.sockets.tmux.Unit.ConditionPathExists or null;
                expected = "!%t/tmux-%U/default";
              };
              testTmuxSocketStartsWithUserManager = {
                expr = user.sockets.tmux.Install.WantedBy or null;
                expected = [ "sockets.target" ];
              };
              # Si el kernel mata un `ld`, el panel (y su agente) sigue vivo
              testPaneSurvivesOomKillOfChild = {
                expr = home.xdg.configFile."systemd/user/tmux-spawn-.scope.d/oom-policy.conf".text or null;
                expected = ''
                  [Scope]
                  OOMPolicy=continue
                '';
              };
            };
          in
          pkgs.runCommand "agent-memory-guard" { } (
            if failures == [ ] then
              "touch $out"
            else
              ''
                echo ${lib.escapeShellArg (lib.generators.toPretty { } failures)} >&2
                exit 1
              ''
          );

        # Pin del feed oficial: api2.cursor.sh/updates/api/download/stable/linux-x64/sand
        grok-bot-version =
          let
            grok = self.packages.${system}.grok-bot;
            failures = lib.runTests {
              testPinnedToOfficialStable = {
                expr = grok.version;
                expected = "0.66.0";
              };
            };
          in
          pkgs.runCommand "grok-bot-version" { } (
            if failures == [ ] then
              "touch $out"
            else
              ''
                echo ${lib.escapeShellArg (lib.generators.toPretty { } failures)} >&2
                exit 1
              ''
          );
      };
    };
}
