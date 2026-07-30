{
  pkgs,
  fetchFromGitHub,
}:
pkgs.vimUtils.buildVimPlugin {
  pname = "vscode.nvim";
  version = "unstable";
  src = fetchFromGitHub {
    owner = "Mofiqul";
    repo = "vscode.nvim";
    rev = "aa1102a7e15195c9cca22730b09224a7f7745ba8";
    hash = "sha256-YGlTlHEuivPJzMyWfk+YmbZqftbj7Mrll8rB3vK3O2A=";
  };
}
