{ pkgs, inputs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;

  cava-osd = pkgs.stdenv.mkDerivation {
    pname = "cava-osd";
    version = "0.1.0";
    src = ./src;

    nativeBuildInputs = with pkgs; [
      wrapGAppsHook3
      gobject-introspection
      inputs.ags.packages.${system}.default
    ];

    buildInputs = [
      pkgs.glib
      pkgs.gjs
      inputs.astal.packages.${system}.io
      inputs.astal.packages.${system}.astal4
      inputs.astal.packages.${system}.cava
    ];

    installPhase = ''
      mkdir -p $out/bin
      ags bundle app.tsx $out/bin/cava-osd
    '';

    preFixup = ''
      gappsWrapperArgs+=(
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.gjs ]}
      )
    '';
  };
in
{
  home-manager.sharedModules = [
    (_: {
      home.packages = [ cava-osd ];
    })
  ];
}
