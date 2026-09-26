{
  pkgs,
  config,
  ...
}:
let
  inherit (config.host) owner;
in
{
  environment.systemPackages = with pkgs; [ mangohud ];

  hjem.users.${owner}.xdg.config.files."MangoHud/MangoHud.conf".text = ''
    legacy_layout=false
    font_file=${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Bold.ttf
    font_size=28
    gpu_list=0
    gpu_stats
    vram
    gpu_temp
    gpu_mem_temp
    cpu_stats
    cpu_temp
    ram
    fps
    fps_color_change
    gpu_name
    frame_timing
    background_alpha=0.6
    fps_color=ff0000,ffff00,00ff00
    background_color=000000
  '';
}
