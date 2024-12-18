{ ... }:
{
  perSystem =
    {
      system,
      pkgs,
      lib,
      inputs',
      ...
    }:
    {
      packages = {
        sf-pro = pkgs.callPackage ./sf-pro { inherit (pkgs) stdenv; };
      };
    };
}
