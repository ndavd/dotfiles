{
  inputs,
  ...
}:
{
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.lenovo-legion-15ach6h-nvidia
  ];

  host = {
    owner = "ndavd";
    name = "wopr";

    primaryMonitor = {
      output = "HDMI-A-1";
      width = 2560;
      height = 1440;
      refreshRate = 240;
      scale = 1.0;
    };
    primaryMonitorHdrCompatibleRefreshRate = 144;
    secondaryMonitor = {
      output = "eDP-1";
      width = 1920;
      height = 1080;
      refreshRate = 120;
      scale = 1.25;
    };

    nvidiaGpu.enable = true;
    cpu = "amd";

    gaming.enable = true;
  };
}
