{ config, lib, pkgs, ... }:
let
  sources = import ./nix/sources.nix { };

  packages = with pkgs; [
    # utilities
    alejandra   # nix formatter
    bitwarden   # password manager
    cachix      # binary cache
    git         # version control
    github-cli  # github from command line
    gron        # greppable json
    htop        # process monitor
    jq          # json processor
    libreoffice # free office suite
    moreutils   # more scripting tools
    ngrok       # port tunneling
    pavucontrol # volume control
    pipr        # interactive pipeline builder
    ripgrep     # recursive grep
    sshpass     # specify ssh password
    xclip       # x clipboard scripting
    xsel        # x clipbaord scripting
    yj          # yaml to json

    # global aliases
    (aliasToPackage {
      gc = ''nix-collect-garbage "$@"'';
      hms = "home-manager switch";
      ldp = "sh -c '(cd ~/.config/nixpkgs/; ./install.sh)'";
      pai = "~/.config/nixpkgs/pull-and-install.sh";
      json2nix = ''
        [[ -n "$1" ]] && json="$(readlink -f "$1")"
        [[ -p /dev/stdin ]] && json=/dev/stdin
        nix-instantiate -E --arg json "$json" '
          { json ? "" }:
          let
            v = builtins.fromJSON (builtins.readFile json);
          in
          builtins.trace v v
        ' &> /dev/stdout \
          | cut -f 2- -d ' ' \
          | alejandra -q
      '';
    })
  ];

in
{

  imports = builtins.map (x: ./modules + ("/" + x)) (builtins.attrNames (builtins.readDir ./modules));

  nixpkgs = {
    config = import ./config.nix;
    overlays = [ (import ./pkgs) ];
  };

  xdg = {
    userDirs = {
      enable = true;
      desktop = "\$HOME";
      documents = "\$HOME/files";
      download = "\$HOME/downloads";
      music = "\$HOME/music";
      pictures = "\$HOME/images";
      videos = "\$HOME/videos";
    };
  };

  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "reed";
    homeDirectory = "/home/reed";
    sessionVariables = {
      EDITOR = "nvim";
    };
    inherit packages;
  };

  systemd.user.startServices = true;

  home.stateVersion = "20.09";
}
