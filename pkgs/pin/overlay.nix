self: pkgs:
let
  lib = pkgs.lib;
  pinned = pkgs.pinned;

  # map defaults to top level
  defaults = pinned
    |> lib.filterAttrs (n: v: lib.hasAttr "default" v)
    |> lib.mapAttrs (n: v: v.default);

  # final = (pinned
  #   |> lib.mapAttrs (n: v: lib.filterAttrs (n2: v2: n2 != "default") v)
  #   |> lib.filterAttrs (n: v: (lib.length (builtins.attrNames v)) == 1)
  #   |> lib.filterAttrs (n: v: !lib.hasAttr n pkgs)
  #   |> builtins.mapAttrs (n: v: builtins.elemAt (builtins.attrValues v) 0)
  # ) // defaults;
in defaults
