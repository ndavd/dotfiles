# WARN: This script is meant to be run from within `fzf --preview`

mime="$(file --mime-type {} | tr ': ' '\n' | tail -1)"
tmp_thumbnail=/tmp/fzf-preview

render_img() {
  kitty icat \
    --clear \
    --transfer-mode=stream \
    --stdin=no \
    --place="${FZF_PREVIEW_COLUMNS}x$FZF_PREVIEW_LINES"@0x0 \
    "$1"
}

# image
if echo "$mime" | grep -q "image/*"; then
  render_img {}
  return
fi

# video
if echo "$mime" | grep -q "video/*"; then
  ffmpegthumbnailer -m -s0 -i {} -o "${tmp_thumbnail}.jpg" &>/dev/null
  render_img "${tmp_thumbnail}.jpg"
  return
fi

# pdf
if echo "$mime" | grep -q "application/pdf"; then
  pdftoppm -jpeg -f 1 -singlefile {} "$tmp_thumbnail" &>/dev/null
  render_img "${tmp_thumbnail}.jpg"
  return
fi

# epub
if echo "$mime" | grep -q "application/epub+zip"; then
  gnome-epub-thumbnailer {} "${tmp_thumbnail}.png" &>/dev/null
  render_img "${tmp_thumbnail}.png"
  return
fi

# clear previous thumbnails
# NOTE: this must be run in the background or else fzf's previews hang; might
# cause performance issues
kitty icat --clear 2>/dev/null &

# directory
if echo "$mime" | grep -q "inode/directory"; then
  ls -1A {}
  return
fi

# text
bat --color=always --plain {}
