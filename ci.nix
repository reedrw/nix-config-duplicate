{
  sources ? import ./nix/sources.nix { },
  pkgs ? import sources.nixpkgs { config = import ./config.nix; }
}:

{

  nixos = (import "${sources.nixpkgs}/nixos" { configuration = import ./system/nixos.nix; }).system;
  nixos-t400 = (import "${sources.nixpkgs}/nixos" { configuration = import ./system/nixos-t400.nix; }).system;
  nixos-t480 = (import "${sources.nixpkgs}/nixos" { configuration = import ./system/nixos-t480.nix; }).system;
  nixos-t520 = (import "${sources.nixpkgs}/nixos" { configuration = import ./system/nixos-t520.nix; }).system;
  nixos-desktop = (import "${sources.nixpkgs}/nixos" { configuration = import ./system/nixos-desktop.nix; }).system;
  home-manager = (import "${sources.home-manager}/home-manager/home-manager.nix" { confPath = ./home.nix; inherit pkgs; }).activationPackage;

}
