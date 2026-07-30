{
  fetchFromGitHub,
  buildNpmPackage,
}:
buildNpmPackage {
  pname = "solhint";
  version = "unstable";
  src = fetchFromGitHub {
    owner = "protofire";
    repo = "solhint";
    rev = "b5d3ec434fdfc5f597ac373ccaf1a13aabb7e56c";
    hash = "sha256-tyaGB2cACGFamom9YYDVz8+P/Gssg8p46maORBbCCpk=";
  };
  npmDepsHash = "sha256-7vEf/UfkuaUxB7hXUKmLiR73lOiqFOTwsz/7LjiO9vU=";
  dontNpmBuild = true;
}
