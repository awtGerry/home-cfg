# Grok Bot - agente de escritorio (Electron), reempaquetado desde el .deb oficial
{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeShellWrapper,
  wrapGAppsHook3,
  alsa-lib,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  glib,
  gtk3,
  libdrm,
  libgbm,
  libGL,
  libnotify,
  libsecret,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  libxscrnsaver,
  libxtst,
  nspr,
  nss,
  pango,
  pipewire,
  udev,
  util-linux,
  vulkan-loader,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "grok-bot";
  version = "0.66.0";

  src = fetchurl {
    url = "https://downloads.cursor.com/grokbot/stable/12fb477da4023dc110998df181ec150d29c355f2/linux/x64/grok-bot_0.66.0_amd64.deb";
    name = "grok-bot-${finalAttrs.version}.deb";
    hash = "sha256-fVYKMKHkanlc73BJHYsuLouReOeloHT/123GGE/QNwk=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    # Si no se usa grapgappshook3 falla la ejecucion
    makeShellWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libdrm
    libgbm
    libxkbcommon
    nspr
    nss
    pango
    (lib.getLib stdenv.cc.cc)
    util-linux # libuuid
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
  ];

  # Librerias que la app carga con dlopen en tiempo de ejecucion
  runtimeDependencies = [
    (lib.getLib udev)
    libGL
    libnotify
    libsecret
    pipewire
    vulkan-loader
    libxscrnsaver
    libxtst
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x $src unpacked
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp -r "unpacked/opt/Grok Bot" $out/share/grok-bot
    cp -r unpacked/usr/share/icons unpacked/usr/share/applications $out/share/

    runHook postInstall
  '';

  # wrapGAppsHook3 no debe envolver el binario directamente; combinamos sus
  # argumentos con makeWrapper para envolver una sola vez
  dontWrapGApps = true;

  postFixup = ''
    makeShellWrapper $out/share/grok-bot/grok-bot $out/bin/grok-bot \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer}}"
  '';

  meta = {
    description = "Grok Bot desktop agent";
    homepage = "https://cursor.com";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "grok-bot";
  };
})
