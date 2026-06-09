{
  lib,
  stdenv,
  requireFile,
  unzip,
  autoPatchelfHook,
  makeWrapper,
  libGL,
  libX11,
  libXcursor,
  libXinerama,
  libXrandr,
  libXi,
  libXext,
  wayland,
  libxkbcommon,
  libpulseaudio,
  alsa-lib,
  pipewire,
  makeDesktopItem,
  copyDesktopItems,
}:

let
  pname = "pngtuber-plus";
  version = "1.4.5";

  desktopItem = makeDesktopItem {
    name = "pngtuber-plus";
    exec = "pngtuber-plus";
    desktopName = "PNGTuber Plus";
    comment = "PNGTuber avatar puppet program with mic-reactive sprites";
    categories = [ "Graphics" "AudioVideo" ];
  };

  # Godot dlopens these at runtime — need them in LD_LIBRARY_PATH
  runtimeLibs = [
    libGL
    libX11
    libXcursor
    libXinerama
    libXrandr
    libXi
    libXext
    wayland
    libxkbcommon
    libpulseaudio
    alsa-lib
    pipewire
  ];

in
stdenv.mkDerivation rec {
  inherit pname version;

  src = requireFile rec {
    name = "PNGT+.zip";
    sha256 = "c1fac87fac268b42faf9a84a2a82ea9611a129572fd8855c89468309078ac0ba";
    message = ''
      Download PNGTuber Plus Linux zip from https://kaiakairos.itch.io/pngtuber-plus
      (Name your own price - $0 works) and place it at ~/PNGT+.zip

      Then add it to the nix store:
        nix-store --add-fixed sha256 ~/PNGT+.zip
    '';
  };

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    runHook preUnpack
    unzip -o "$src"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/pngtuber-plus

    install -Dm755 "PNGTUBER PLUS ${version} LINUX.x86_64" $out/lib/pngtuber-plus/
    install -Dm644 "PNGTUBER PLUS ${version} LINUX.pck" $out/lib/pngtuber-plus/
    install -Dm755 libgdexample.linux.template_release.x86_64.so $out/lib/pngtuber-plus/

    # Godot dlopens runtime libs — wrap with LD_LIBRARY_PATH
    makeWrapper $out/lib/pngtuber-plus/"PNGTUBER PLUS ${version} LINUX.x86_64" $out/bin/pngtuber-plus \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"

    runHook postInstall
  '';

  desktopItems = [ desktopItem ];

  meta = with lib; {
    description = "Lightweight PNGTuber avatar puppet program with mic-reactive sprites";
    homepage = "https://kaiakairos.itch.io/pngtuber-plus";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "pngtuber-plus";
  };
}
