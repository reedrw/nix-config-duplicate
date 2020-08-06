{ cfg, lib, pkgs, ... }:

let

  sources = import ./nix/sources.nix;

  mpv-webm = (sources.mpv-webm);

  mpv_thumbnail_script = pkgs.stdenv.mkDerivation {
    name = "mpv_thumbnail_script";
    src = (sources.mpv_thumbnail_script);

    nativeBuildInputs = [ pkgs.python3 ];

    patchPhase = ''
      patchShebangs ./concat_files.py
    '';

    installPhase = ''
      mkdir -p "$out"
      cp -v *.lua "$out"
    '';

  };

in
{
  programs.mpv = {
    enable = true;
    config = {
      profile = "gpu-hq";
      osc = "no";
    };
  };
  xdg.configFile = {
    "mpv/scripts/webm.lua".source = "${mpv-webm}/build/webm.lua";
    "mpv/scripts/mpv_thumbnail_script_client_osc.lua".source = "${mpv_thumbnail_script}/mpv_thumbnail_script_client_osc.lua";
    "mpv/scripts/mpv_thumbnail_script_server.lua".source = "${mpv_thumbnail_script}/mpv_thumbnail_script_server.lua";
    "mpv/script-opts/mpv_thumbnail_script.conf".text = ''
      autogenerate_max_duration=0
    '';
  };
}

