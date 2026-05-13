{ host, pkgs, ... }:
{
  # these will be overlayed in nixpkgs automatically.
  # for built pkgs to be available, they must be used with pkgs.<name>
  # for example: environment.systemPackages = with pkgs; [pokego];

  pokego = pkgs.callPackage ./pokego.nix { };
  portainer-mcp = pkgs.callPackage ./portainer-mcp.nix { };
  bolder-weather-card = pkgs.callPackage ./bolder-weather-card.nix { };
  weather-forecast-card = pkgs.callPackage ./weather-forecast-card.nix { };
}
