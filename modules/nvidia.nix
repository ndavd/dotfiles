{
  config,
  lib,
  ...
}:
let
  inherit (config.host) gpu;
in
{
  config = lib.mkIf (gpu == "nvidia") {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement.enable = true;
    };
    nixpkgs.config.cudaSupport = true;
  };
}
