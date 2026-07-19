{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (config.host) owner;
  zellij-cb = lib.getExe (pkgs.pkgsCross.wasi32.callPackage ../../pkgs/zellij-cb.nix { });
in
{
  environment.systemPackages = with pkgs; [
    zellij

    (writeShellApplication {
      name = "z";
      runtimeInputs = [
        zellij
        fd
        fzf
      ];
      text = builtins.readFile ./z-script.sh;
    })
  ];

  hjem.users.${owner}.xdg.config.files = {
    "zellij/config.kdl".source = ./config/config.kdl;
    "zellij/layouts/default.kdl".source = pkgs.replaceVars ./config/layouts/default.kdl {
      inherit zellij-cb;
    };
    "zellij/layouts/project.kdl".source = pkgs.replaceVars ./config/layouts/project.kdl {
      inherit zellij-cb;
    };
  };
}
