{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-git = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.follows = "";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      hosts = [ "wopr" ];
      pkgs = nixpkgs.legacyPackages.${system};
      treefmt = import ./treefmt.nix { inherit inputs pkgs; };
    in
    {
      inherit system hosts;

      nixosConfigurations = nixpkgs.lib.genAttrs hosts (
        name:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs system; };
          modules = [
            ./modules
            ./hosts/${name}
          ];
        }
      );

      formatter.${system} = treefmt.config.build.wrapper;

      packages.${system}.nvim = pkgs.callPackage ./pkgs/nvim { inherit inputs system; };
    };
}
