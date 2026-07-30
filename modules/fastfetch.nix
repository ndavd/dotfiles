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
      fastfetch
    ];
  };

  hjem.users.${owner}.xdg.config.files."fastfetch/config.jsonc" = {
    generator = lib.generators.toJSON { };
    value = {
      display = {
        color = {
          keys = "blue";
          title = "blue";
        };
      };
      modules = [
        "title"
        "os"
        "host"
        "kernel"
        "uptime"
        "shell"
        "display"
        "wm"
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "disk"
        "locale"
      ];
    };
  };
}
