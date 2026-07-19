{
  pkgs,
  ...
}:
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    audio.enable = true;
    jack.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
  ];
}
