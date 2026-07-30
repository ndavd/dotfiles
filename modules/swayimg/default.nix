{
  pkgs,
  config,
  ...
}:
let
  inherit (config.host) owner;
in
{
  environment.systemPackages = with pkgs; [
    swayimg
  ];

  hjem.users.${owner}.xdg.config.files = {
    "swayimg/init.lua".source = ./config/init.lua;
    "swayimg/stubs/swayimg.meta.lua".source = "${pkgs.swayimg}/share/swayimg/swayimg.lua";
  };
}
