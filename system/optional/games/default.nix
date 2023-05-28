{ inputs, outputs, config, lib, pkgs, ... }:
let
  components = lib.importJSON ./components.json;
  aaglPkgs = inputs.aagl.packages.x86_64-linux;
  # aaglPkgs = import /home/reed/files/aagl-gtk-on-nix;

  unwrapped = aaglPkgs.anime-game-launcher.unwrapped;
  # aagl = with aaglPkgs.anime-game-launcher; override {
  #   unwrapped = unwrapped.overrideAttrs (old: rec {
  #     src = inputs.an-anime-game-launcher;
  #     version = pkgs.shortenRev inputs.an-anime-game-launcher.rev;
  #     cargoDeps = pkgs.rustPlatform.importCargoLock {
  #       lockFile = "${src}/Cargo.lock";
  #       outputHashes = {
  #         "anime-game-core-1.10.1" = "sha256-144mNiHSHypmQU02BXMyKnUA3h+0KPAWTCyfZmvwE0A=";
  #         "anime-launcher-sdk-1.4.2" = "sha256-Zk0M/Ll8iyU/SVa134pSzLDjGxPD0UyeQMhSzEveHZY=";
  #       };
  #     };
  #   });
  # };
  aagl = aaglPkgs.anime-game-launcher.override {
    unwrapped = unwrapped.override {
      customIcon = builtins.fetchurl components.aagl.icon;
    };
  };

  mve = lib.optionalString config.services.mullvad-vpn.enable "mullvad-exclude";

  anime-game-launcher = with pkgs; let
    wrapper = aliasToPackage { anime-game-launcher = "${mve} ${aagl}/bin/anime-game-launcher"; };
  in symlinkJoin {
    inherit (unwrapped) pname version name;
    paths = with aagl.passthru; [ wrapper icon desktopEntry ];
  };
in
{
  imports = [
    inputs.aagl.nixosModules.default
  ];

  # nixpkgs.overlays = [ aaglPkgs.overlay ];

  programs.steam = with pkgs; {
    enable = true;
    package = steam.override {
      extraLibraries = pkgs: [ gtk4 libadwaita config.hardware.opengl.package ];
      extraPkgs = pkgs: [
        xdg-user-dirs
        mangohud
      ];
      # https://github.com/NixOS/nixpkgs/issues/230246
      extraProfile = ''
        export GSETTINGS_SCHEMA_DIR="${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}/glib-2.0/schemas/"
      '';
    };
  };

  networking.mihoyo-telemetry.block = true;

  # programs.honkers-railway-launcher = {
  #   enable = true;
  #   package = with aaglPkgs.honkers-railway-launcher; override {
  #     unwrapped = unwrapped.override {
  #       customIcon = builtins.fetchurl components.hrl.icon;
  #     };
  #   };
  # };

  environment.systemPackages = with pkgs; [
    r2mod_cli
    nurPkgs.genshin-account-switcher
    anime-game-launcher
    (aliasToPackage {
      gsi = "anime-game-launcher --run-game";
      gas = ''genshin-account-switcher "$@"'';
      hsr = "honkers-railway-launcher --run-game";
    })
  ];

}
