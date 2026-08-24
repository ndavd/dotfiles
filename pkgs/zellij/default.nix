{
  pkgs,
  copy-command ? "wl-copy",
}:
let
  zellij-cb = pkgs.zellijPlugins.cb;

  configDir = pkgs.linkFarm "zellij-config" {
    "config.kdl" = pkgs.replaceVars ./config/config.kdl { inherit copy-command; };
    "layouts/default.kdl" = pkgs.replaceVars ./config/layouts/default.kdl { inherit zellij-cb; };
    "layouts/project.kdl" = pkgs.replaceVars ./config/layouts/project.kdl { inherit zellij-cb; };
  };

  z = pkgs.writeShellApplication {
    name = "z";
    runtimeInputs = with pkgs; [
      zellij
      fd
      fzf
    ];
    text = builtins.readFile ./z-script.sh;
  };
in
pkgs.symlinkJoin {
  name = "zellij";
  paths = [
    pkgs.zellij
    z
  ];
  nativeBuildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    for bin in "$out"/bin/*; do
      wrapProgram "$bin" --set ZELLIJ_CONFIG_DIR ${configDir}
    done
  '';
}
