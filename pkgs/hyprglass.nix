{
  lib,
  stdenv,
  fetchFromGitHub,
  hyprland,
  pkg-config,
  pixman,
  libdrm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprglass";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "hyprnux";
    repo = "hyprglass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6qa0PoeKfGSpXpILgp2yuYfRmrQKjDSQWpy8q27u1uE=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    hyprland
    pixman
    libdrm
  ] ++ hyprland.buildInputs;

  buildPhase = ''
    runHook preBuild
    make CXX=$CXX
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib
    cp hyprglass.so $out/lib/libhyprglass.so
    runHook postInstall
  '';

  meta = {
    description = "Liquid Glass inspired plugin for Hyprland";
    homepage = "https://github.com/hyprnux/hyprglass";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
