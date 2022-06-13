{ config, lib, pkgs, ... }:
let
  tmuxconf = builtins.toFile "tmuxconf" ''
    set -g status off
    set -g destroy-unattached on
    set -g mouse on
    set -g default-terminal 'tmux-256color'
    set -ga terminal-overrides ',alacritty:RGB'
    set -s escape-time 0
    set -g history-limit 10000
  '';
in
{

  home.packages = [ pkgs.scientifica ]; # font

  programs.alacritty.enable = true;
  xdg.configFile."alacritty/alacritty.yml".text = ''
    import:
      - ${import ./theme.nix { inherit config; } }

    live_config_reload: true

    cursor:
      style: Underline

    font:
      normal:
        family: scientifica
        style: Medium

      bold:
        family: scientifica
        style: Bold

      italic:
        family: scientifica
        style: Italic

      bold_italic:
        family: scientifica
        style: Bold

      size: 8

    window:
      dynamic_padding: true
      padding:
        x: 15
        y: 15

    shell:
      program: ${pkgs.tmux}/bin/tmux
      args:
        - -f
        - ${tmuxconf}
  '';
}
