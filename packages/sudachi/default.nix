{
  stdenv,
  lib,
  fetchurl,
  p7zip,
  makeWrapper,
  makeDesktopItem,
  autoPatchelfHook,
  # QT
  kdePackages,
  # Multimedia
  libva,
  libvdpau,
  libdrm,
  # Sistema
  openssl,
  zlib,
  glib,
  gtk3,
  cairo,
  pango,
  libGL,
  xorg,
}:
stdenv.mkDerivation rec {
  pname = "sudachi";
  version = "1.0.11";

  src = fetchurl {
    url = "https://github.com/emuplace/sudachi.emuplace.app/releases/download/v${version}/sudachi-linux-v${version}.7z";
    sha256 = "sha256-uR0cxnWzE82Z9tXeMcef9QUBEcYRLrbkJuXcSlrLbsI=";
  };

  nativeBuildInputs = [
    p7zip
    makeWrapper
    autoPatchelfHook
    kdePackages.wrapQtAppsHook
    # wrapQtAppsHook
  ];

  buildInputs = [
    # Qt6
    kdePackages.qtbase
    kdePackages.qtwebengine
    kdePackages.qttools
    # Multimedia
    libva
    libvdpau
    libdrm
    # Sistema
    openssl
    stdenv.cc.cc.lib
    zlib
    glib
    gtk3
    cairo
    pango
    libGL
    xorg.libX11
    xorg.libXrender
    xorg.libXfixes
    xorg.libXdamage
    xorg.libXcomposite
    xorg.libXext
  ];

  unpackPhase = ''
    7z x $src
  '';

  installPhase = ''
    mkdir -p $out/{bin,opt/sudachi}

    install -m755 sudachi $out/opt/sudachi/
    install -m755 sudachi-cmd $out/opt/sudachi/
    install -m755 sudachi-room $out/opt/sudachi/
    install -m644 tzdb2nx $out/opt/sudachi/

    makeWrapper $out/opt/sudachi/sudachi $out/bin/sudachi \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs} \
      --prefix QT_PLUGIN_PATH : ${kdePackages.qtbase}/lib/qt-6/plugins

    # Crear archivo .desktop
    mkdir -p $out/share/applications
    cp $desktopItem/share/applications/* $out/share/applications/
  '';

  desktopItem = makeDesktopItem {
    name = "sudachi";
    exec = "sudachi";
    icon = "sudachi";
    desktopName = "Sudachi";
    genericName = "Nintendo Switch Emulator";
    categories = [
      "Game"
      "Emulator"
    ];
  };

  # meta = with lib; {
  #   description = "Nintendo Switch Emulator";
  #   homepage = "https://sudachi.emuplace.app";
  #   license = licenses.gpl2Plus;
  #   platforms = platforms.linux;
  #   maintainers = with maintainers; [ ];
  # };
}
