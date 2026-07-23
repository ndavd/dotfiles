{
  pkgs,
  lib,
  ...
}:
let
  fzfPreview = import ../pkgs/fzf-preview { inherit pkgs; };
in
{
  programs.fzf.fuzzyCompletion = true;

  environment = {
    systemPackages = with pkgs; [ fzf ];
    sessionVariables = {
      FZF_DEFAULT_COMMAND = "fd --unrestricted --full-path --color=always -E '/.*' -E node_modules -E .git -E target";
      FZF_DEFAULT_OPTS = lib.concatStringsSep " " [
        "--ansi"
        "--info=inline"
        "--color=gutter:#000000"
        "--no-scrollbar"
        "--border=none"
        "--preview='${fzfPreview}/bin/fzf-preview {}'"
        "--preview-window=right,50%,border-left"
      ];
    };
  };
}
