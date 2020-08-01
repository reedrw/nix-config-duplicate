{ config, lib, pkgs, ... }:

let

  sources = import ./nix/sources.nix;

  ranger-archives = with sources.ranger-archives;
  pkgs.fetchFromGitHub {
    owner = owner;
    repo = repo;
    rev = rev;
    sha256 = sha256;
  };

  ccat = pkgs.writeShellScriptBin "bat"''
    ${pkgs.bat}/bin/bat --theme=base16 "$@"
  '';

  rangercommand = pkgs.writeShellScriptBin "rangercommand"''
    cd $@
    ranger
    $SHELL
  '';

  rangerlaunch = pkgs.writeShellScriptBin "rangerlaunch"''
    st -e ${rangercommand}/bin/rangercommand $@
  '';

  ranger = pkgs.ranger.overrideAttrs (
    oldAttrs: rec {
      buildInputs = oldAttrs.buildInputs ++ [ pkgs.makeWrapper ];
      postInstall = ''
        cat << EOF > $out/share/applications/ranger.desktop
        [Desktop Entry]
        Type=Application
        Name=ranger
        Comment=Launches the ranger file manager
        Icon=utilities-terminal
        Exec=${rangerlaunch}/bin/rangerlaunch
        Categories=ConsoleOnly;System;FileTools;FileManager
        MimeType=inode/directory;
        Keywords=File;Manager;Browser;Explorer;Launcher;Vi;Vim;Python
        EOF

        wrapProgram $out/bin/ranger \
          --prefix PATH : ${ccat}/bin \
          --prefix PATH : ${pkgs.atool}/bin \
          --prefix PATH : ${pkgs.dragon-drop}/bin \
          --prefix PATH : ${pkgs.jq}/bin \
          --prefix PATH : ${pkgs.poppler_utils}/bin \
          --prefix PATH : ${pkgs.ueberzug}/bin \
          --prefix PATH : ${pkgs.zip}/bin
      '';
    }
  );

in
{

  home.packages = [ ranger ];

  xdg.configFile = {
    "ranger/rc.conf".text = ''
        alias touch shell touch
        map e console touch%space
        map D shell dragon -a -x %p
        set preview_images true
        set preview_images_method ueberzug
      '';

    "ranger/rifle.conf".text = ''
        ext gif = mpv -- "$@"
        ext mkv = mpv -- "$@"
        ext mp4 = mpv -- "$@"
        ext webm = mpv -- "$@"
        ext nix = ''${VISUAL:-$EDITOR} -- "$@"
        ext sh  = ''${VISUAL:-$EDITOR} -- "$@"
      '';
    "ranger/plugins/compress.py".source = "${ranger-archives}/compress.py";
    "ranger/plugins/extract.py".source = "${ranger-archives}/extract.py";
  };

}

