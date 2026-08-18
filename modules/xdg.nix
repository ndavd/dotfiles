{
  pkgs,
  ...
}:
{
  xdg = {
    mime = {
      enable = true;
      defaultApplications = {
        "video/*" = "mpv.desktop";
        "audio/*" = "mpv.desktop";
        "image/*" = "swayimg.desktop";
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
