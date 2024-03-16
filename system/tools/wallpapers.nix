{ lib, pkgs, ... }:

{
  home.file = {
    "Pictures/Wallpapers/road.jpg".source = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/l8/wallhaven-l8vp7y.jpg";
    };
    "Pictures/Wallpapers/mvc2.jpg".source = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/yj/wallhaven-yjdg5l.jpg";
    };
    "Pictures/Wallpapers/mustang.jpg".source = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/jx/wallhaven-jxqok5.jpg";
    };
    "Pictures/Wallpapers/linux_room.jpg".source = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/1p/wallhaven-1pwez3.png";
    };
  };
}
