{
  inputs,
  lib,
  config,
  pkgs,
  system,
  ...
}:
let
  inherit (config.host)
    owner
    nvidiaGpu
    launcher
    primaryMonitor
    secondaryMonitor
    primaryMonitorHdrCompatibleRefreshRate
    ;

  hyprland-git = inputs.hyprland-git.packages.${system}.hyprland;
  xdg-desktop-portal-hyprland-git =
    inputs.hyprland-git.packages.${system}.xdg-desktop-portal-hyprland;

  primaryMonitorBlock = with primaryMonitor; /* lua */ ''
    primary_monitor = {
      output = '${output}',
      width = ${toString width},
      height = ${toString height},
      refresh_rate = ${toString refreshRate},
    },
  '';
  secondaryMonitorBlock = lib.optionalString (secondaryMonitor != null) (
    with secondaryMonitor;
    /* lua */ ''
      secondary_monitor = {
        output = '${output}',
        width = ${toString width},
        height = ${toString height},
        refresh_rate = ${toString refreshRate},
      },
    ''
  );
  primaryMonitorHdrCompatibleRefreshRateBlock =
    lib.optionalString (primaryMonitorHdrCompatibleRefreshRate != null)
      /* lua */ ''
        primary_monitor_hdr_compatible_refresh_rate = ${toString primaryMonitorHdrCompatibleRefreshRate},
      '';
in
{
  programs.hyprland = {
    enable = true;
    package = hyprland-git;
    portalPackage = xdg-desktop-portal-hyprland-git;
  };

  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  xdg.portal.config.hyprland.default = [
    "hyprland"
    "gtk"
  ];
  hjem.users.${owner}.xdg.config.files = {
    "hypr/hyprland.lua".source = ./config/hyprland.lua;
    "hypr/vars.lua".text = /* lua */ ''
      return {
        terminal = '$TERMINAL',
        browser = '$BROWSER',
        menu = '${launcher}',
        ${primaryMonitorBlock}
        ${secondaryMonitorBlock}
        ${primaryMonitorHdrCompatibleRefreshRateBlock}
        hyprpolkitagent = '${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent',
      }
    '';
    "hypr/stubs".source = "${hyprland-git}/share/hypr/stubs";
  };

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      QT_QPA_PLATFORM = "wayland";
    }
    // lib.optionalAttrs nvidiaGpu.enable {
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";
    };

    systemPackages = with pkgs; [
      hyprshot

      wlr-randr
      wf-recorder
      networkmanagerapplet
      libnotify
      qalculate-gtk
      wireplumber
      brightnessctl
      qt6.qtwayland
      qt5.qtwayland
    ];
  };
}
