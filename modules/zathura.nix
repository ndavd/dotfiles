{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config.host) owner;
in
{
  environment = {
    systemPackages = with pkgs; [
      zathura
    ];
  };

  hjem.users.${owner}.xdg.config.files."zathura/zathurarc" = {
    generator = lib.generators.toKeyValue {
      mkKeyValue = k: v: "set ${k} ${toString v}";
    };
    value = {
      selection-clipboard = "clipboard";
      recolor = true;
      recolor-reverse-video = true;
    };
  };
}
