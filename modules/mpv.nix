{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.host) owner primaryMonitorHdrCompatibleRefreshRate;
in
{
  environment.systemPackages = with pkgs; [
    (mpv.override {
      scripts = with mpvScripts; [
        uosc
        thumbfast
        quality-menu
      ];
    })

    (writeShellApplication {
      name = "is-hdr";
      runtimeInputs = [ mediainfo ];
      text = ''
        hdr_format="$(mediainfo "$1" | grep --color=always "HDR format" || true)"
        if [ "$hdr_format" = "" ]; then echo "Not HDR"; else echo -e "$hdr_format"; fi
      '';
    })

    # safety net needed since high hz + hdr crashes the display
    (writeShellApplication {
      name = "mpv-hdr";
      text = ''
        MAX_HZ=${toString primaryMonitorHdrCompatibleRefreshRate}
        over_limit=$(hyprctl monitors -j | jq -r --argjson max "$MAX_HZ" '.[] | select(.focused==true) | (.refreshRate > $max)')
        if [[ "$over_limit" == "true" ]]; then
          echo "mpv-hdr: focused monitor is above safe max hz. Exiting..." >&2
        else
          mpv --target-colorspace-hint=yes "$@"
        fi
      '';
    })
  ];

  hjem.users.${owner}.xdg.config.files = {
    "mpv/mpv.conf" = {
      generator = lib.generators.toKeyValue { };
      value = {
        # ensure best quality
        ytdl-format = ''"bestvideo*+bestaudio/best"'';
        profile = "high-quality";
        # uosc
        osd-bar = "no";
        border = "no";
        # use vulkan backend
        vo = "gpu-next";
        gpu-api = "vulkan";
        gpu-context = "waylandvk";
        # hdr
        target-colorspace-hint = "no"; # use mpv-hdr
        target-colorspace-hint-mode = "source";
      };
    };
    "mpv/input.conf" = {
      generator = lib.generators.toKeyValue {
        mkKeyValue = lib.generators.mkKeyValueDefault { } " ";
      };
      value = {
        # stream quality for video
        "F" = "script-binding quality_menu/video_formats_toggle";
        # stream quality for audio
        "Alt+f" = "script-binding quality_menu/audio_formats_toggle";
        "[" = "add speed -0.1";
        "]" = "add speed +0.1";
        "{" = "add speed -0.25";
        "}" = "add speed +0.25";
      };
    };
  };
}
