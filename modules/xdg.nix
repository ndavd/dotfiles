{
  pkgs,
  ...
}:
let
  mimeapps = {
    defaultApplications = {
      "video/x-matroska" = "mpv.desktop";
      "video/mp4" = "mpv.desktop";
      "image/png" = "sxiv.desktop";
      "image/jpeg" = "sxiv.desktop";
      "application/pdf" = "org.pwmt.zathura.desktop";
      "x-scheme-handler/tg" = "userapp-Telegram Desktop-IREOR1.desktop";
      "x-scheme-handler/clickup" = "ClickUp.desktop";
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
      "x-scheme-handler/slack" = "slack.desktop";
    };
    addedAssociations = {
      "x-scheme-handler/tg" = "userapp-Telegram Desktop-IREOR1.desktop";
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
    };
  };
in
{
  xdg = {
    mime = {
      enable = true;
      inherit (mimeapps) defaultApplications addedAssociations;
    };
    icons.enable = true;
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config.common.default = [ "gtk" ];
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };
}
