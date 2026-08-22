{
  config,
  lib,
  ...
}:
let
  inherit (config.host) nvidiaGpu;
in
{
  config = lib.mkIf nvidiaGpu.enable {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement.enable = true;
    };
    nixpkgs.config.cudaSupport = true;
  };
}
