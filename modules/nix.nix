{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.host) owner gpu;
in
{
  nixpkgs.config.allowUnfree = true;

  programs.nh = {
    enable = true;
    flake = "/home/${owner}/projects/dotfiles";
  };

  nix = {
    channel.enable = false;

    optimise = {
      automatic = true;
      dates = [ "13:00" ];
    };

    settings = {
      builders-use-substitutes = true;
      trusted-users = [
        "root"
        "@wheel"
      ];
      download-buffer-size = 500000000;

      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
      ]
      ++ lib.optionals (gpu == "nvidia") [
        "https://cache.nixos-cuda.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ]
      ++ lib.optionals (gpu == "nvidia") [
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    nix-tree
    nix-output-monitor
    dix
  ];
}
