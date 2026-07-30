{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (config.host) owner;
  configPath = "ripgrep/config";
in
{
  environment = {
    systemPackages = with pkgs; [ ripgrep ];
    sessionVariables = {
      RIPGREP_CONFIG_PATH = "${toString config.hjem.users.${owner}.xdg.config.directory}/${configPath}";
    };
  };

  hjem.users.${owner}.xdg.config.files.${configPath} = {
    generator = lib.generators.toKeyValue {
      mkKeyValue = k: v: if v == "" then "--${k}" else "--${k}=${v}";
    };
    value = {
      hidden = "";
      smart-case = "";
      glob = "!.git/";
    };
  };
}
