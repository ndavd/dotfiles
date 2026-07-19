{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config.host) owner gaming;
in
{
  config = lib.mkIf gaming.enable {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
    };

    programs.gamemode.enable = true;

    environment = {
      sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${owner}/.steam/root/compatibilitytools.d";
      };

      systemPackages = with pkgs; [
        protonup-ng
        winetricks
        heroic
      ];
    };
  };
}
