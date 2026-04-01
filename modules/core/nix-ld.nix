{ pkgs, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Common libraries needed by non-Nix binaries
      stdenv.cc.cc
      zlib
      zstd
      curl
      openssl
    ];
  };
}
