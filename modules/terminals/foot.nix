{
  config,
  lib,
  ...
}:
let
  inherit (config.host) terminal;
in
{
  environment = {
    sessionVariables = lib.mkIf (terminal == "foot") {
      TERMINAL = terminal;
    };
  };

  programs.foot = {
    enable = true;
    theme = "kitty";
    settings = {
      main = {
        font = "monospace:size=12,Symbols Nerd Font Mono:size=12";
        pad = "0x0";
        gamma-correct-blending = "yes";
      };
      tweak = {
        surface-bit-depth = "8-bit";
      };
      text-bindings = {
        "\\x1b\\x0d" = "Shift+Return";
      };
    };
  };
}
