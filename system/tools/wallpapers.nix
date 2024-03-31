{ lib, pkgs, config, ... }:

let
  dir = "${config.home.picDir}/Wallpapers";
in
{
  home.file = {
    "${dir}/road.jpg".source = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/l8/wallhaven-l8vp7y.jpg";
      hash = "sha256-MxmB+im6XVMUo8f0JJmzDNmPjnsB7RR2JpNKHYCKEDs=";
    };
    "${dir}/mustang.jpg".source = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/jx/wallhaven-jxqok5.jpg";
      hash = "sha256-bIumVBh8oq4VHpCtNjX78CsgscTBvIFqF4FlzA4vRkk=";
    };
    "${dir}/red.png".source = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/39/wallhaven-39mmpy.png";
      hash = "sha256-9v4ySeY10i9F5qVMGgojtDyInt+BzeU4L3f6rpZV6iU=";
    };
    "${dir}/white.png".source = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/73/wallhaven-739jvy.png";
      hash = "sha256-hCqsN+Sr7tT3OLgig+gwhiP1Ry1sZ7/NsVTB3NunbiA=";
    };
    "${dir}/games.png".source = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/0j/wallhaven-0jz2ly.png";
      hash = "sha256-Vjqg/rHn7qI7wV1lhXyHhXk+bf4ROitQpitglzR+Ds0=";
    };
  };
}
