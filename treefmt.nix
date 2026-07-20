{
  projectRootFile = "flake.nix";
  programs = {
    nixfmt.enable = true;
    deadnix.enable = true;
    statix.enable = true;
    stylua.enable = true;
    qmlformat.enable = true;
    kdlfmt.enable = true;
    taplo.enable = true;
    rumdl-format.enable = true;
    shfmt.enable = true;
    yamlfmt.enable = true;
  };
}
