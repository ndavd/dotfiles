{
  fetchFromGitHub,
  rustPlatform,
  lld,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zellij-cb";
  version = "0.1.2";
  src = fetchFromGitHub {
    owner = "ndavd";
    repo = "zellij-cb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j1RrLyDHVrdMs+iIUrA2X1pFCBFlBPQQCyEbsna/iIo=";
  };
  cargoHash = "sha256-HXaeA4GU9aTNo8f9Phs/BIV3kXnjZUoqbgFAfa0GseE=";
  env.RUSTFLAGS = "-C linker=wasm-ld";
  nativeBuildInputs = [ lld ];

  meta.mainProgram = "zellij-cb";
})
