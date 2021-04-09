let
  sources = import ./nix/sources.nix;

  devshell = import "${sources.devshell}/overlay.nix";

  hm-overlay = self: super: {
    home-manager = super.callPackage "${sources.home-manager}/home-manager" { };
  };

  pre-commit = self: super: {
    pre-commit = (import
      (pkgs.fetchzip {
        url = "https://github.com/nixos/nixpkgs/archive/7138a338b58713e0dea22ddab6a6785abec7376a.zip";
        sha256 = "1asgl1hxj2bgrxdixp3yigp7xn25m37azwkf3ppb248vcfc5kil3";
      })
      { }).gitAndTools.pre-commit;
  };

  pkgs = import sources.nixpkgs {
    overlays = [
      devshell
      hm-overlay
      pre-commit
    ];
  };

in
pkgs.devshell.fromTOML ./devshell.toml
