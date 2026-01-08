{ host, pkgs, ... }:
{
  # these will be overlayed in nixpkgs automatically.
  # for example: environment.systemPackages = with pkgs; [pokego];
  pokego = pkgs.callPackage ./pokego.nix { };
  oc-web = pkgs.callPackage ./oc-web.nix { };
}
