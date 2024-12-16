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
    let
      upkgs = inputs'.nixpkgs.legacyPackages;
    in
    {
      packages = lib.mkMerge [
        {
          "sf/pro" = upkgs.callPackage ./sf-pro { };
          "rofi/unicode" = upkgs.callPackage ./rofi-unicode { };
        }
      ];
    };
}
