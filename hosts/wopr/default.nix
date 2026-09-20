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
      refreshRate = 144;
      scale = 1.0;
    };
    secondaryMonitor = {
      output = "eDP-1";
      width = 1920;
      height = 1080;
      refreshRate = 120;
      scale = 1.25;
    };

    gpu = "nvidia";
    gaming.enable = true;
    laptop.enable = true;
  };
}
