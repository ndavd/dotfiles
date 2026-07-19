{
  lib,
  ...
}:
let
  monitorType = lib.types.submodule {
    options = {
      output = lib.mkOption {
        type = lib.types.nonEmptyStr;
      };
      width = lib.mkOption {
        type = lib.types.int;
      };
      height = lib.mkOption {
        type = lib.types.int;
      };
      refreshRate = lib.mkOption {
        type = lib.types.int;
      };
    };
  };
in
{
  options.host = {
    name = lib.mkOption {
      type = lib.types.nonEmptyStr;
      description = "Hostname";
    };

    owner = lib.mkOption {
      type = lib.types.nonEmptyStr;
    };

    gaming.enable = lib.mkEnableOption "gaming capabilities";

    nvidiaGpu.enable = lib.mkEnableOption "NVIDIA GPU";

    cpu = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "amd"
          "intel"
        ]
      );
      default = null;
    };

    primaryMonitor = lib.mkOption {
      type = monitorType;
    };
    primaryMonitorHdrCompatibleRefreshRate = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
    };

    secondaryMonitor = lib.mkOption {
      type = lib.types.nullOr monitorType;
      default = null;
    };

    terminal = lib.mkOption {
      type = lib.types.enum [
        "foot"
        "kitty"
      ];
      default = "foot";
    };

    browser = lib.mkOption {
      type = lib.types.enum [
        "brave"
        "firefox"
      ];
      default = "brave";
    };

    launcher = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "qs ipc call launcher run";
    };
  };
}
