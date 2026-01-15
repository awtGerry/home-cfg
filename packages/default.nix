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
        # sudachi = pkgs.callPackage ./sudachi { inherit (pkgs) stdenv; }; # Github page is gone.
        # shadps4 = pkgs.callPackage ./shadps4 { inherit (pkgs) stdenv; };
      };
    };
}
