{
  config,
  pkgs,
  ...
}:
let
  inherit (config.host) owner;
in
{
  environment.systemPackages = with pkgs; [
    quickshell
  ];

  hjem.users.${owner}.xdg.config.files."quickshell".source = ./config;
}
