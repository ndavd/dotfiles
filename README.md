# Dotfiles

My NixOS configuration flake ❄️. A minimal, highly-functional, reproducible, declarative system.

> [!NOTE]
> For my older Arch Linux system configuration (Wayland and X11), refer to the `legacy/arch` branch.

| Main Software                                                                         | NixOS (Wayland)                                                                      |
| ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| **Editor**                                                                            | [Neovim](https://neovim.io/)                                                         |
| **Shell**                                                                             | [Zsh](https://www.zsh.org/)                                                          |
| **Terminal Emulator**                                                                 | [Foot](https://codeberg.org/dnkl/foot)                                               |
| **Terminal Workspace**                                                                | [Zellij](https://zellij.dev/) (with [zellij-cb](https://github.com/ndavd/zellij-cb)) |
| **Window Manager**                                                                    | [Hyprland](https://hypr.land/)                                                       |
| **Status Bar, App Launcher, Notifications, OSD, Wallpaper, Idle Manager, Lockscreen** | [Quickshell](https://quickshell.org/)                                                |
| **Filesystem**                                                                        | [BTRFS](https://btrfs.readthedocs.io/) on a LUKS encrypted partition                 |

| Directory                | Description               |
| ------------------------ | ------------------------- |
| [./hosts/](./hosts/)     | Per machine configuration |
| [./modules/](./modules/) | Shared feature modules    |
| [./pkgs/](./pkgs/)       | Custom packages           |

- `$HOME` management: Done with [`hjem`](https://github.com/feel-co/hjem) instead of Home Manager as
  it aligns better with the simplicity I strive for.
- Short term recoverability: Running daily BTRFS subvolume snapshots of `/home`.

## Run my self-contained editor

You can try the custom `nvim` setup that I use every day without having to be on NixOS.

It is completely self-contained (bundled with all runtime dependencies, Neovim plugins, LSPs,
linters, formatters, Tree-sitter grammars, and of course, my own configuration).

Install the [Nix](https://nixos.org/download/) package manager and just run:

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
