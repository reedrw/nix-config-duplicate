{ pkgs, ... }:
{
  load-layouts = pkgs.writeShellApplication {
    name = "load-layouts.sh";
    runtimeInputs = [ pkgs.wmctrl ];
    text = (builtins.readFile ./load-layouts.sh);
  };

  selecterm = pkgs.writeShellApplication {
    name = "select-term.sh";
    runtimeInputs = [ pkgs.slop ];
    text = (builtins.readFile ./select-term.sh);
  };

  record = pkgs.writeShellApplication {
    name = "record.sh";
    runtimeInputs = with pkgs; [
      slop
      ffmpeg-full
      libnotify
    ];
    text = (builtins.readFile ./record.sh);
  };

  clipboard-clean = let
    sources = import ./clipboard-clean-patches/nix/sources.nix { };
    unalix = pkgs.python3Packages.buildPythonPackage {
      name = "Unalix";
      src = sources.Unalix;

      patches = [ ./clipboard-clean-patches/update.patch ];

      doCheck = false;
    };
    in pkgs.writeShellApplication {
    name = "clipboard-clean";
    runtimeInputs = with pkgs; [
      coreutils
      xclip
      (python3.withPackages(ps: [ unalix ]))
    ];
    text = (builtins.readFile ./clipboard-clean.sh);
  };

  bwmenu-patched = pkgs.nurPkgs.bitwarden-rofi.overrideAttrs (_: {
    src = pkgs.fetchFromGitHub {
      owner = "mattydebie";
      repo = "bitwarden-rofi";
      rev = "a5f6348fae6a96499a27a25a79f83ed37da81716";
      sha256 = "sha256-QggtjWrt27obx8Igjj2DVtIZ5XLAf/iJSPsUmZkY4Yk=";
    };
    patches = [
      ./bwmenu-patches/copy-totp.patch
      ./bwmenu-patches/fix-quotes.patch
    ];
  });

  volume = pkgs.writeShellApplication {
    name = "volume";
    runtimeInputs = with pkgs; [
      glib
      pulseaudio
    ];
    text = (builtins.readFile ./volume.sh);
  };

  mpv-dnd = pkgs.writeShellApplication {
    name = "mpv-dnd";
    runtimeInputs = with pkgs; [
      procps
      coreutils
      xdotool
    ];
    text = (builtins.readFile ./mpv-dnd.sh);
  };

  pause-suspend = pkgs.writeShellApplication {
    name = "pause-suspend";
    runtimeInputs = with pkgs; [
      xdotool
    ];
    text = (builtins.readFile ./pause-suspend.sh);
  };
}
