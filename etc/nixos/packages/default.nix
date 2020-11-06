{ pkgs, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: rec {
    qrcp = pkgs.callPackage ./qrcp.nix {};
  };
}
