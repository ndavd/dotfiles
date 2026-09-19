{
  config,
  pkgs,
  ...
}:
let
  inherit (config.host) owner laptop;
in
{
  environment = {
    systemPackages = with pkgs; [
      quickshell
    ];
    sessionVariables = {
      QS_STATUSBAR_BATTERY = if laptop.enable then "1" else "0";
    };
  };

  hjem.users.${owner}.xdg.config.files."quickshell".source = ./config;
}
