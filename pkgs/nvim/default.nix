{
  pkgs,
  inputs,
  system,
}:
let
  customPkgs = [
    (pkgs.callPackage ../solhint.nix { })
  ];

  customPlugins = [
    (pkgs.callPackage ../vscode-nvim.nix { })
    (pkgs.callPackage ../noir-nvim.nix { })
  ];

  plugins = with pkgs.vimPlugins; [
    # Mini all things
    mini-nvim

    # Treesitter
    nvim-ts-autotag
    nvim-ts-context-commentstring
    nvim-treesitter.withAllGrammars

    # LSP
    friendly-snippets
    blink-cmp
    nvim-lspconfig
    conform-nvim
    nvim-lint
  ];

  requiredPkgs =
    with pkgs;
    [
      # Runtime
      tree-sitter
      fd
      ripgrep

      # LSPs
      bash-language-server
      clang-tools
      cmake-language-server
      vscode-langservers-extracted # cssls, html, jsonls
      eslint
      eslint_d
      gopls
      graphql-language-service-cli
      lua-language-server
      rust-analyzer
      vscode-solidity-server
      tailwindcss-language-server
      taplo
      texlab
      typescript-language-server
      vim-language-server
      yaml-language-server
      dockerfile-language-server
      prisma-language-server
      astro-language-server
      sqls
      nixd
      biome
      kdePackages.qtdeclarative

      # Formatters
      foundry
      go
      nixfmt
      prettier
      prettierd
      qt6.qtdeclarative
      rumdl
      rustfmt
      shellharden
      shfmt
      sql-formatter
      stylua
      tex-fmt
      yamlfmt
      kdlfmt

      # Linters
      vim-vint
      texlive.bin.chktex
      clippy
      statix
    ]
    ++ customPkgs;

  configDir = ./config;
in
pkgs.wrapNeovim inputs.neovim-nightly.packages.${system}.neovim {
  extraMakeWrapperArgs = "--prefix PATH : ${pkgs.lib.makeBinPath requiredPkgs}";
  configure = {
    customRC = ''
      set runtimepath^=${configDir}
      source ${configDir}/init.vim
    '';
    packages.myPlugins.start = plugins ++ customPlugins;
  };
}
