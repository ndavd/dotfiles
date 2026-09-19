{
  ...
}:
{
  imports = [
    ./hardware.nix
  ];

  host = {
    owner = "ndavd";
    name = "javelin";

    primaryMonitor = {
      output = "DP-1";
      width = 2560;
      height = 1440;
      refreshRate = 240;
      scale = 1.0;
    };
    secondaryMonitor = {
      output = "HDMI-A-1";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      scale = 1.0;
    };

    gpu = "amd";

    gaming.enable = true;
  };
}
