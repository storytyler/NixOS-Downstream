{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  dart-sass,
  colors ? (import ./palette.nix { }),
}:
stdenvNoCC.mkDerivation rec {
  pname = "phocus";
  version = "0cf0eb35a927bffcb797db8a074ce240823d92de";

  src = fetchFromGitHub {
    owner = "phocus";
    repo = "gtk";
    rev = version;
    sha256 = "sha256-URuoDJVRQ05S+u7mkz1EN5HWquhTC4OqY8MqAbl0crk=";
  };

  patches = [
    ./npm.diff
    ./gradients.diff
    ./substitute.diff
  ];

  postPatch =
    let
      c = colors;
    in
    ''
      substituteInPlace scss/gtk-3.0/_colors.scss \
        --replace "@fg@"        "#${c.foreground}" \
        --replace "@fg2@"       "#${c.color7}" \
        --replace "@bg0@"       "#${c.darker}" \
        --replace "@bg1@"       "#${c.background}" \
        --replace "@bg2@"       "#${c.mbg}" \
        --replace "@bg3@"       "#${c.mbg}" \
        --replace "@bg4@"       "#${c.color0}" \
        --replace "@red@"       "#${c.color1}" \
        --replace "@lred@"      "#${c.color9}" \
        --replace "@orange@"    "#${c.color3}" \
        --replace "@lorange@"   "#${c.color11}" \
        --replace "@yellow@"    "#${c.color3}" \
        --replace "@lyellow@"   "#${c.color11}" \
        --replace "@green@"     "#${c.color2}" \
        --replace "@lgreen@"    "#${c.color10}" \
        --replace "@cyan@"      "#${c.color6}" \
        --replace "@lcyan@"     "#${c.color15}" \
        --replace "@blue@"      "#${c.color4}" \
        --replace "@lblue@"     "#${c.color12}" \
        --replace "@purple@"    "#${c.color5}" \
        --replace "@lpurple@"   "#${c.color13}" \
        --replace "@pink@"      "#${c.color5}" \
        --replace "@lpink@"     "#${c.color13}" \
        --replace "@primary@"   "#${c.accent-primary}" \
        --replace "@secondary@" "#${c.accent-secondary}"
    '';

  nativeBuildInputs = [ dart-sass ];

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = with lib; {
    description = "Minimal GTK3 theme with color customization via SCSS substitution";
    homepage = "https://github.com/phocus/gtk";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
