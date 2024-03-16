{ lib, pkgs, ... }:

{
  home.file = {
    "Pictures/Wallpapers/road.jpg".source = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/l8/wallhaven-l8vp7y.jpg";
      hash = "sha256-MxmB+im6XVMUo8f0JJmzDNmPjnsB7RR2JpNKHYCKEDs=";
    };
    "Pictures/Wallpapers/mvc2.jpg".source = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/yj/wallhaven-yjdg5l.jpg";
      hash = "sha256-QqABGDLC9Ui2E1CHkOPrexQavZWHoTmQADZne/ITBLk=";
    };
    "Pictures/Wallpapers/mustang.jpg".source = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/jx/wallhaven-jxqok5.jpg";
      hash = "sha256-bIumVBh8oq4VHpCtNjX78CsgscTBvIFqF4FlzA4vRkk=";
    };
    "Pictures/Wallpapers/linux_room.jpg".source = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/1p/wallhaven-1pwez3.png";
      hash = "sha256-nKHd5oVhZ22SzremayBhw0eRYpF85nNieaxIT2nhn6U=";
    };
  };
}
