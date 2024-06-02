#!/usr/bin/env bash
# WARN: This script is meant to be run from within `fzf --preview`

entry="$1"
mime="$(file --mime-type "$entry" | tr ': ' '\n' | tail -1)"
tmp_thumbnail=/tmp/fzf-preview

render_img() {
  kitty icat \
    --clear \
    --transfer-mode=stream \
    --stdin=no \
    --place="${FZF_PREVIEW_COLUMNS}x$FZF_PREVIEW_LINES"@0x0 \
    "$1"
}

# svg
if echo "$mime" | grep -q "image/svg+xml"; then
  magick "$entry" -flatten "${tmp_thumbnail}.jpg" &>/dev/null
  render_img "${tmp_thumbnail}.jpg"
  exit 0
fi

# image
if echo "$mime" | grep -q "image/*"; then
  render_img "$entry"
  exit 0
fi

# video
if echo "$mime" | grep -q "video/*"; then
  ffmpegthumbnailer -m -s0 -i "$entry" -o "${tmp_thumbnail}.jpg" &>/dev/null
  render_img "${tmp_thumbnail}.jpg"
  exit 0
fi

# pdf
if echo "$mime" | grep -q "application/pdf"; then
  pdftoppm -jpeg -f 1 -singlefile "$entry" "$tmp_thumbnail" &>/dev/null
  render_img "${tmp_thumbnail}.jpg"
  exit 0
fi

# epub
if echo "$mime" | grep -q "application/epub+zip"; then
  gnome-epub-thumbnailer "$entry" "${tmp_thumbnail}.png" &>/dev/null
  render_img "${tmp_thumbnail}.png"
  exit 0
fi

# clear previous thumbnails
# NOTE: this must be run in the background or else fzf previews hang; might
# cause performance issues
kitty icat --clear 2>/dev/null &

# directory
if echo "$mime" | grep -q "inode/directory"; then
  ls -1A "$entry"
  exit 0
fi

# text
bat --color=always --plain "$entry"
