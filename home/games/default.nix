{ config, pkgs, ... }:
let
  quakeDir = "${config.home.homeDirectory}/.local/share/Steam/steamapps/common/Quake";
  quake = pkgs.wrapPackage pkgs.ironwail (x: ''
    pushd ${quakeDir}
      ${x} "\$@"
    popd
  '');
in
{
  home.packages = with pkgs; [
    prismlauncher
    quake
  ];
  xdg.dataFile = with config.lib.stylix.scheme; {
    "PrismLauncher/themes/base16/theme.json".text = builtins.toJSON {
      colors = {
        AlternateBase = "#${base02}";
        Base = "#${base00}";
        BrightText = "#${base08}";
        Button = "#${base02}";
        ButtonText = "#${base05}";
        Highlight = "#${base0D}";
        HighlightedText = "#000000";
        Link = "#${base0D}";
        Text = "#${base05}";
        ToolTipBase = "#${base06}";
        ToolTipText = "#${base06}";
        Window = "#${base02}";
        WindowText = "#${base05}";
        fadeAmount = 0.5;
        fadeColor = "#${base02}";
      };
      name = "Base16";
      qssFilePath = "themeStyle.css";
      widgets = "Fusion";
    };
    "PrismLauncher/themes/base16/themeStyle.css".text = ''
      QToolTip { color: #ffffff; background-color: #${base0D}; border: 1px solid white; }
    '';
    "PrismLauncher/themes/base16/resources".source = pkgs.emptyDirectory;
  };
}
