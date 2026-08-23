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

    book-of-profits = {
      url = "github:ndavd/book-of-profits";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      ...
    }@inputs:
    let
      listNixFilesRecursive =
        module:
        nixpkgs.lib.filter (n: nixpkgs.lib.strings.hasSuffix ".nix" n) (
          nixpkgs.lib.filesystem.listFilesRecursive module
        );

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      hosts = {
        wopr = "x86_64-linux";
      };

      forEachSystem = nixpkgs.lib.genAttrs systems;

      perSystem = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        in
        {
          nvim = pkgs.callPackage ./pkgs/nvim { inherit inputs system; };
          zellij = pkgs.callPackage ./pkgs/zellij { };
          fmt = treefmtEval.config.build.check self;
          formatter = treefmtEval.config.build.wrapper;
        }
      );

      hostChecks = nixpkgs.lib.mapAttrs' (name: system: {
        name = system;
        value = {
          "${name}" = self.nixosConfigurations.${name}.config.system.build.toplevel;
        };
      }) hosts;
    in
    {
      inherit hosts;

      nixosConfigurations = nixpkgs.lib.mapAttrs (
        name: system:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs system; };
          modules = [ ./hosts/${name} ] ++ (listNixFilesRecursive ./modules);
        }
      ) hosts;

      packages = forEachSystem (system: {
        inherit (perSystem.${system}) nvim zellij;
      });

      checks = nixpkgs.lib.recursiveUpdate (forEachSystem (system: {
        inherit (perSystem.${system}) nvim zellij fmt;
      })) hostChecks;

      formatter = forEachSystem (system: perSystem.${system}.formatter);
    };
}
