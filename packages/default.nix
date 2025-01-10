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
        sudachi = pkgs.callPackage ./sudachi { inherit (pkgs) stdenv; };
        # extract-xiso = pkgs.callPackage ./xiso { inherit (pkgs) stdenv; }; # No funciona aun
      };
    };
}
