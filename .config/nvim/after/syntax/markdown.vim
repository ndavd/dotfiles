" Strikethrough
syn region mdStrike matchgroup=mdStrikeText start="\S\zs\~\~\|\~\~\ze\S" end="\S\zs\~\~\|\~\~\ze\S" skip="\\\~" concealends

highlight mdStrike gui=strikethrough
highlight link mdStrikeText mdStrike

" Underline
syn region mdUnderline matchgroup=mdUnderlineText start="\S\zs__\|__\ze\S" end="\S\zs__\|__\ze\S" skip="\\\~" concealends

highlight mdUnderline gui=underline
highlight link mdUnderlineText mdUnderline
