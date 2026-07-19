{
  pkgs,
  fetchFromGitHub,
}:
pkgs.vimUtils.buildVimPlugin {
  pname = "noir-nvim";
  version = "unstable";
  src = fetchFromGitHub {
    owner = "noir-lang";
    repo = "noir-nvim";
    rev = "974085422a6dab055821803a0c2177ced673510d";
    hash = "sha256-4kMz5PJ0Gz+Q/m1siFMo8bGl07Xo5UiHLE77uN6BDso=";
  };
}
