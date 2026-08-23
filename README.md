# Dotfiles

My NixOS configuration flake ❄️. _A minimal, highly-functional, reproducible, declarative system._

> [!NOTE]
> For my older Arch Linux system configuration (Wayland and X11), refer to the `legacy/arch` branch.

| Main Software          | NixOS (Wayland)                                                                          |
| ---------------------- | ---------------------------------------------------------------------------------------- |
| **Editor**             | [`nvim`](https://neovim.io/)                                                             |
| **Shell**              | [`zsh`](https://www.zsh.org/)                                                            |
| **Terminal Emulator**  | [`foot`](https://codeberg.org/dnkl/foot)                                                 |
| **Terminal Workspace** | [`zellij`](https://zellij.dev/) (with [`zellij-cb`](https://github.com/ndavd/zellij-cb)) |
| **Window Manager**     | [`hyprland`](https://hypr.land/)                                                         |
| **System UI**[^1]      | [`quickshell`](https://quickshell.org/)                                                  |
| **Filesystem**         | [`btrfs`](https://btrfs.readthedocs.io/) on a LUKS encrypted partition                   |

- `$HOME` management: Done with [`hjem`](https://github.com/feel-co/hjem) instead of Home Manager as
  it aligns better with the simplicity I strive for.
- Short term recoverability: Running daily BTRFS subvolume snapshots of `/home`.
- Automatic weekly updates.

## Architecture

| Directory                 | Description               |
| ------------------------- | ------------------------- |
| [`./hosts`](./hosts/)     | Per machine configuration |
| [`./modules`](./modules/) | Shared feature modules    |
| [`./pkgs`](./pkgs/)       | Custom packages           |

## Run my self-contained packages

Parts of my everyday setup are packaged to run anywhere. All you need is the
[`nix`](https://nixos.org/download/) package manager, no NixOS required.

| Package                     | Description                                                                                                                                             | Command                                                                                               |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| [`#nvim`](./pkgs/nvim/)     | **My editor `nvim`** comes bundled with all runtime dependencies, Neovim plugins, LSPs, linters, formatters, Tree-sitter grammars, and my configuration | `nix run github:ndavd/dotfiles#nvim`                                                                  |
| [`#zellij`](./pkgs/zellij/) | **My terminal workspace `zellij`** comes bundled with all runtime dependencies, `z` script, Zellij plugins, and my configuration                        | `nix run github:ndavd/dotfiles#zellij` (`nix shell github:ndavd/dotfiles#zellij --command z` for `z`) |

## Run checks

```shell
nix flake check
```

## Format the project

With the help of `treefmt`, every single file in this repository can be formatted with a single
command:

```shell
nix fmt
```

[^1]: Includes status bar, application launcher, notifications, OSD, wallpaper, idle manager,
    lockscreen.
