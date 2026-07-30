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
- Automatic weekly updates

## Architecture

| Directory                 | Description               |
| ------------------------- | ------------------------- |
| [`./hosts`](./hosts/)     | Per machine configuration |
| [`./modules`](./modules/) | Shared feature modules    |
| [`./pkgs`](./pkgs/)       | Custom packages           |

## Run my self-contained editor

You can try the custom `nvim` setup that I use every day without having to be on NixOS.

It is completely self-contained (bundled with all runtime dependencies, Neovim plugins, LSPs,
linters, formatters, Tree-sitter grammars, and of course, my own configuration).

Install the [`nix`](https://nixos.org/download/) package manager and just run:

```shell
nix run github:ndavd/dotfiles#nvim
```

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

[^1]: Includes: Status Bar, App Launcher, Notifications, OSD, Wallpaper, Idle Manager, Lockscreen.
