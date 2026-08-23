{ pkgs }:
let
  zellij-cb = pkgs.zellijPlugins.cb;

  configDir = pkgs.linkFarm "zellij-config" {
    "config.kdl" = ./config/config.kdl;
    "layouts/default.kdl" = pkgs.replaceVars ./config/layouts/default.kdl { inherit zellij-cb; };
    "layouts/project.kdl" = pkgs.replaceVars ./config/layouts/project.kdl { inherit zellij-cb; };
  };

  zellij-wrapped = pkgs.symlinkJoin {
    name = "zellij-wrapped";
    paths = [ pkgs.zellij ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/zellij --set ZELLIJ_CONFIG_DIR ${configDir}
    '';
  };

  z = pkgs.writeShellApplication {
    name = "z";
    runtimeInputs = [
      zellij-wrapped
      pkgs.fd
      pkgs.fzf
    ];
    text = builtins.readFile ./z-script.sh;
  };
in
pkgs.symlinkJoin {
  name = "zellij";
  paths = [
    zellij-wrapped
    z
  ];
}
