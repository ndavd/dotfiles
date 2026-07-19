{ pkgs }:
pkgs.writeShellApplication {
  name = "fzf-preview";
  runtimeInputs = with pkgs; [
    file # mime detection
    kitty # icat
    imagemagick # magick (svg -> jpg)
    ffmpegthumbnailer # video thumbnails
    poppler-utils # pdftoppm
    gnome-epub-thumbnailer # epub thumbnails
    bat # text preview
    coreutils # ls, tr, tail
    gnugrep # grep
  ];
  text = builtins.readFile ./preview-script.sh;
}
