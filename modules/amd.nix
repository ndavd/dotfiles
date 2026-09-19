{
  config,
  lib,
  ...
}:
let
  inherit (config.host) gpu;
in
{
  config = lib.mkIf (gpu == "amd") {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
      amdgpu.opencl.enable = true;
    };
    nixpkgs.config.rocmSupport = true;
  };
}
