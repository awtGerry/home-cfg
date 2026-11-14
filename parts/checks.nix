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

        # Bot Screen de Hermes: el escritorio Xvnc + Xfce de cada bot (ver docs/agent-host.md).
        # Los binarios son los REQUIRED_BINARIES de tools/bot_desktop/runtime.py; Hermes los busca en el PATH.
        hermes-bot-screen =
          let
            nixos = self.nixosConfigurations.artemis.config;
            home = self.homeConfigurations."gerry@artemis".config;
            failures = lib.runTests {
              # cua-driver (el computer_use de los bots) es un binario precompilado que corre por nix-ld
              testNixLdServesCuaDriverLibraries = {
                expr = map (p: lib.elem p nixos.programs.nix-ld.libraries) [
                  pkgs.libX11
                  pkgs.libXi
                  pkgs.libxkbcommon
                ];
                expected = [
                  true
                  true
                  true
                ];
              };
            };
            bins = [
              "Xvnc"
              "xfwm4"
              "xfce4-panel"
              "xfdesktop"
              "xfsettingsd"
              "dbus-run-session"
              "xauth"
              "xdpyinfo"
              "setxkbmap"
              "xprop"
              "xsetroot"
              "xset"
            ];
          in
          pkgs.runCommand "hermes-bot-screen" { } (
            if failures != [ ] then
              ''
                echo ${lib.escapeShellArg (lib.generators.toPretty { } failures)} >&2
                exit 1
              ''
            else
              ''
                missing=""
                for b in ${lib.escapeShellArgs bins}; do
                  [ -x ${home.home.path}/bin/$b ] || missing="$missing $b"
                done
                [ -z "$missing" ] || { echo "falta en el PATH de home:$missing" >&2; exit 1; }
                # Sin xfconfd en el D-Bus privado de la pantalla, Xfce ignora el dock y el fondo que siembra Hermes
                [ -e ${home.home.path}/share/dbus-1/services/org.xfce.Xfconf.service ] \
                  || { echo "xfconfd no se puede activar por D-Bus" >&2; exit 1; }
                touch $out
              ''
          );

        # Pin del feed oficial: api2.cursor.sh/updates/api/download/stable/linux-x64/sand
        grok-bot-version =
          let
            grok = self.packages.${system}.grok-bot;
            failures = lib.runTests {
              testPinnedToOfficialStable = {
                expr = grok.version;
                expected = "0.75.5";
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

        hermes-desktop =
          let
            home = self.homeConfigurations."gerry@artemis".config;
            installs = program: lib.any (p: (p.meta.mainProgram or null) == program) home.home.packages;
            failures = lib.runTests {
              # Sin FileChooser en el portal, Electron cae al dialogo de GTK y
              # este aborta (cambiar la foto de un bot cerraba Hermes)
              testPortalProvidesFileChooser = {
                expr = lib.any (p: (p.pname or null) == "xdg-desktop-portal-gtk") home.xdg.portal.extraPortals;
                expected = true;
              };
              testDesktopAppIsTheNixBuild = {
                expr = installs "hermes-desktop";
                expected = true;
              };
              # El CLI y el gateway siguen en la instalacion que se actualiza sola
              testCliStaysWithSelfUpdatingInstall = {
                expr = installs "hermes";
                expected = false;
              };
            };
          in
          pkgs.runCommand "hermes-desktop" { } (
            if failures == [ ] then
              "touch $out"
            else
              ''
                echo ${lib.escapeShellArg (lib.generators.toPretty { } failures)} >&2
                exit 1
              ''
          );

        # Hyprland >= 0.57 solo lee hyprland.lua: si HM escribe hyprland.conf,
        # arranca con el default (sin atajos, monitores ni waybar).
        hyprland-config =
          let
            artemis = self.homeConfigurations."gerry@artemis";
            home = artemis.config;
            hypr = home.wayland.windowManager.hyprland;
            luaFile = home.xdg.configFile."hypr/hyprland.lua" or null;
            # artemis no prende estas ramas; Hyprland tambien debe aceptarlas
            allBranches =
              (artemis.extendModules {
                modules = [
                  {
                    theme.baseScheme = lib.mkForce "e-ink";
                    theme.variant = lib.mkForce "light";
                    wayland.windowManager.hyprland.visuals = {
                      animation.enable = true;
                      transparency.enable = true;                    };
                  }
                ];
              }).config;
            configs = [
              luaFile.source
              allBranches.xdg.configFile."hypr/hyprland.lua".source
            ];
            failures = lib.runTests {
              testWritesLuaConfig = {
                expr = luaFile != null && !(home.xdg.configFile ? "hypr/hyprland.conf");
                expected = true;
              };
              # Ya existe un hyprland.lua (el default de Hyprland) que HM debe reemplazar
              testReplacesExistingStub = {
                expr = luaFile.force or false;
                expected = true;
              };
            };
          in
          pkgs.runCommand "hyprland-config" { } (
            if failures != [ ] then
              ''
                echo ${lib.escapeShellArg (lib.generators.toPretty { } failures)} >&2
                exit 1
              ''
            else
              ''
                export HOME=$TMPDIR XDG_RUNTIME_DIR=$TMPDIR
                for cfg in ${lib.escapeShellArgs configs}; do
                  ${hypr.finalPackage}/bin/Hyprland --verify-config -c $cfg > log 2>&1 \
                    || { sed -n '/Config parsing result/,$p' log >&2; exit 1; }
                done
                # Lo que faltaba al arrancar con el default
                for want in 'hl.monitor(' 'hl.workspace_rule(' 'hl.bind(' '/bin/start'; do
                  grep -qF "$want" ${luaFile.source} || { echo "falta en hyprland.lua: $want" >&2; exit 1; }
                done
                touch $out
              ''
          );

        # Notificaciones "glass card": tarjeta translucida arriba a la derecha
        notifications =
          let
            home = self.homeConfigurations."gerry@artemis".config;
            dunst = home.services.dunst;
            # Home Manager envuelve cada seccion de dunst como { data = ...; }
            section = name: dunst.settings.${name}.data or { };
            global = section "global";
            notificationRules = builtins.filter (
              r: (r.match.namespace or null) == "notifications"
            ) home.wayland.windowManager.hyprland.visuals.layerrules;
            failures = lib.runTests {
              testDunstRunsAsUserService = {
                expr = dunst.enable;
                expected = true;
              };
              testCardsStackTopRight = {
                expr = global.origin or null;
                expected = "top-right";
              };
              testCardsAreRounded = {
                expr = global.corner_radius or null;
                expected = 12;
              };
              testCardsHaveThinFrame = {
                expr = global.frame_width or null;
                expected = 1;
              };
              # Fondo con alpha: el blur de Hyprland se ve a traves de la tarjeta
              testCardBackgroundIsTranslucent = {
                expr = global.background or null;
                expected = "#0c1110b3";
              };
              testNormalFrameMatchesWaybarAccent = {
                expr = global.frame_color or null;
                expected = "#2f6f64";
              };
              testCriticalFrameIsRed = {
                expr = (section "urgency_critical").frame_color or null;
                expected = "#eb4d4b";
              };
              # Los clics de pantalla no deben quedar atrapados por la tarjeta
              testCardsCanBeDismissedWithMouse = {
                expr = global.mouse_left_click or null;
                expected = "close_current";
              };
              testHyprlandBlursNotifications = {
                expr = lib.any (r: r.blur or false) notificationRules;
                expected = true;
              };
              # Sin ignore_alpha el blur pinta un rectangulo detras de las esquinas redondeadas
              testBlurIgnoresTransparentCorners = {
                expr = lib.any (r: r ? ignore_alpha) notificationRules;
                expected = true;
              };
            };
          in
          pkgs.runCommand "notifications" { } (
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
