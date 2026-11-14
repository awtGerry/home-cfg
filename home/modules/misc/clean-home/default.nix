# Saca de ~ lo que las herramientas escriben ahi por defecto.
# Se exporta en toda la sesion (no solo en zsh) para que apps graficas, LSPs,
# agentes y servicios de systemd --user usen las mismas rutas.
_:
{ config, lib, ... }:
let
  inherit (config.xdg)
    cacheHome
    configHome
    dataHome
    stateHome
    ;

  relocations = {
    CARGO_HOME = "${dataHome}/cargo";
    RUSTUP_HOME = "${dataHome}/rustup";
    GOPATH = "${dataHome}/go";
    GOMODCACHE = "${cacheHome}/go/mod";
    NPM_CONFIG_CACHE = "${cacheHome}/npm";
    BUN_INSTALL = "${dataHome}/bun";
    NUGET_PACKAGES = "${cacheHome}/NuGetPackages";
    DOTNET_CLI_HOME = "${dataHome}/dotnet";
    DOCKER_CONFIG = "${configHome}/docker";
    ANDROID_USER_HOME = "${dataHome}/android";
    ANDROID_HOME = "${dataHome}/android/sdk";
    WINEPREFIX = "${dataHome}/wine";
    PYTHON_HISTORY = "${stateHome}/python_history";
    NODE_REPL_HISTORY = "${stateHome}/node_repl_history";
    PSQL_HISTORY = "${stateHome}/psql_history";
    PULSE_COOKIE = "${configHome}/pulse/cookie";
    TEXMFVAR = "${cacheHome}/texlive/texmf-var";
  };
in
{
  # Exporta XDG_*_HOME (antes solo los exportaba zsh)
  xdg.enable = true;

  home.sessionVariables = relocations;
  systemd.user.sessionVariables = relocations;

  home.sessionPath = [
    "${relocations.CARGO_HOME}/bin"
    "${relocations.GOPATH}/bin"
  ];
}
