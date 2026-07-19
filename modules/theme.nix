{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config.host) owner;

  theme = "Adwaita";
  font = "Monospace";
  fontSize = "10";
  cursorSize = "24";

  qtConf = {
    Appearance = {
      icon_theme = theme;
      standard_dialogs = "xdgdesktopportal";
      style = "${theme}-Dark";
    };
    Fonts = {
      general = ''"${font},${fontSize},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
      fixed = ''"${font},${fontSize},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
    };
  };
in
{
  environment = {
    systemPackages = with pkgs; [
      adw-gtk3
      adwaita-icon-theme
      adwaita-qt
      adwaita-qt6
    ];
    sessionVariables = {
      XCURSOR_THEME = theme;
      XCURSOR_SIZE = cursorSize;
      GTK_THEME = "adw-gtk3-dark:dark";
    };
  };

  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            gtk-theme = "adw-gtk3-dark";
            icon-theme = theme;
            font-name = "${font} ${fontSize}";
            document-font-name = "${font} ${fontSize}";
            monospace-font-name = "${font} ${fontSize}";
            color-scheme = "prefer-dark";
            gtk-enable-primary-paste = false; # disable middle click paste
            enable-animations = true;
          };
        };
      }
    ];
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  hjem.users.${owner}.xdg.config.files = {
    "qt5ct/qt5ct.conf" = {
      generator = lib.generators.toINI { };
      value = qtConf;
    };
    "qt6ct/qt6ct.conf" = {
      generator = lib.generators.toINI { };
      value = qtConf;
    };
  };
}
