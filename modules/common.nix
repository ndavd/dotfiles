{
  pkgs,
  config,
  inputs,
  system,
  ...
}:
let
  inherit (config.host) owner name browser;
  fzfPreview = import ../pkgs/fzf-preview { inherit pkgs; };
in
{
  imports = [
    inputs.hjem.nixosModules.default
    inputs.nix-index-database.nixosModules.default
  ];

  nixpkgs.hostPlatform = system;

  users.users.${owner} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
  };

  hjem = {
    users.${owner} = {
      user = owner;
      directory = "/home/${owner}";
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  hardware = {
    enableAllFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };

  networking = {
    hostName = name;

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
  };

  programs = {
    direnv.enable = true;
    gnupg.agent.enable = true;
    bat.enable = true;
    fzf.fuzzyCompletion = true;
    bash.shellInit = /* bash */ ''
      export HISTFILE="/dev/null"
    '';
  };

  services = {
    power-profiles-daemon.enable = true;
    upower.enable = true;
    udisks2.enable = true;
    resolved.enable = true;
  };

  virtualisation.docker.enable = true;

  fonts = {
    fontconfig.defaultFonts.monospace = [ "JetBrains Mono" ];
    packages = with pkgs; [
      jetbrains-mono
      nerd-fonts.symbols-only
    ];
  };

  environment = {
    sessionVariables = {
      BROWSER = browser;
      XDG_CONFIG_HOME = toString config.hjem.users.${owner}.xdg.config.directory;
      FZF_DEFAULT_COMMAND = "fd --unrestricted --full-path --color=always -E '/.*' -E node_modules -E .git -E target";
      FZF_DEFAULT_OPTS = ''
        --ansi
        --info=inline
        --color=gutter:#000000
        --no-scrollbar
        --border=none
        --preview='${fzfPreview}/bin/fzf-preview {}'
        --preview-window=right,50%,border-left
      '';
    };

    shellAliases = {
      g = "git";
      grep = "grep --colour=auto";
      egrep = "egrep --colour=auto";
      fgrep = "fgrep --colour=auto";
      ffprobe = "ffprobe -hide_banner";
      drop = "dragon-drop";
      bat = "bat -p";
      hinit = "start-hyprland";

      # force usage of flake equivalents
      nix-build = "echo 'use nix build instead'";
      nix-channel = "echo 'use flakes inputs instead'";
      nix-collect-garbage = "echo 'use nix store gc instead'";
      nix-copy-closure = "echo 'use nix copy instead'";
      nix-env = "echo 'use nix profile instead'";
      nix-hash = "echo 'use nix hash instead'";
      nix-instantiate = "echo 'use nix eval / nix derivation instead'";
      nix-prefetch-url = "echo 'use nix store prefetch-file instead'";
      nix-shell = "echo 'use nix shell / nix develop / nix run instead'";
    };

    systemPackages = with pkgs; [
      inputs.book-of-profits.packages.${system}.default

      audacity
      brave
      dragon-drop
      claude-code
      diffutils
      (element-desktop.override {
        commandLineArgs = "--password-store=gnome-libsecret";
      })
      element-web
      ffmpeg
      file
      firefox
      fzf
      fd
      ripgrep
      wl-clipboard
      curl
      gimp
      gnumake
      htop
      jq
      man-pages
      obs-studio
      obsidian
      telegram-desktop
      p7zip
      poppler
      sxiv
      texliveBasic
      tree
      unrar
      yt-dlp
      zathura
    ];
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly. See `man configuration.nix`.
  system.stateVersion = "26.05"; # Did you read the comment?
}
