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
      scale = lib.mkOption {
        type = lib.types.float;
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

    laptop.enable = lib.mkEnableOption "laptop capabilities";

    gaming.enable = lib.mkEnableOption "gaming capabilities";

    gpu = lib.mkOption {
      type = lib.types.enum [
        "nvidia"
        "amd"
      ];
    };

    primaryMonitor = lib.mkOption {
      type = monitorType;
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
