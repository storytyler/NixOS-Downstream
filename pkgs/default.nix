{ host, pkgs, ... }:
{
  # these will be overlayed in nixpkgs automatically.
  # for built pkgs to be available, they must be used with pkgs.<name>
  # for example: environment.systemPackages = with pkgs; [pokego];

  pokego = pkgs.callPackage ./pokego.nix { };
  portainer-mcp = pkgs.callPackage ./portainer-mcp.nix { };
  layout-card = pkgs.callPackage ./layout-card.nix { };
}
