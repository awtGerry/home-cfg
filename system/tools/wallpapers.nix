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
    "${dir}/nyc.jpg".source = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/q6/wallhaven-q6ov1r.jpg";
      hash = "sha256-TYiHSwANdmdIT7o3v1wjy0fRcENDjGALKjxQOI979wo=";
    };
    "${dir}/anime-beach.jpg".source = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/72/wallhaven-72yzje.jpg";
      hash = "sha256-Bo0dbBX0/21fy2gvmCIVkLJYaNQPTB9sKigXzGQ9QIE=";
    };
    "${dir}/mustang.jpg".source = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/jx/wallhaven-jxqok5.jpg";
      hash = "sha256-bIumVBh8oq4VHpCtNjX78CsgscTBvIFqF4FlzA4vRkk=";
    };
    "${dir}/linux_room.jpg".source = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/1p/wallhaven-1pwez3.png";
      hash = "sha256-nKHd5oVhZ22SzremayBhw0eRYpF85nNieaxIT2nhn6U=";
    };
  };
}
