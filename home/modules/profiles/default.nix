_:
{ config, lib, ... }:

let
  # Funcion para convertir una lista de nombres en perfiles habilitados.
  profileEnabler =
    let
      # l es el resultado acumulado.
      # r es el perfil que esta siendo procesado.
      reducer = l: r: { "${r}".enable = true; } // l;
    in
    builtins.foldl' reducer { } config.activeProfiles;
in
{
  _file = ./default.nix;

  # Modulo para aceptar la lista de perfiles.
  options.activateProfiles = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
  };

  # Aplica los perfiles habilitados en la configuracion.
  config.profiles = profileEnabler;

  # TODO: Agregar esto a notas luego borrar :)
  # Ejemplo:
  # En lugar de esto:
  # profiles = {
  #   dev.enable = true;
  #   gaming.enable = true;
  # };
  # Se simplifica a:
  # activeProfiles = [ "dev" "gaming" ];
}
