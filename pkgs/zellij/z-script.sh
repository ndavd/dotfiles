if [[ ${1:-} == "l" ]]; then
  session="$(zellij ls -s -n | fzf)"
  zellij \
    -l project \
    attach \
    "$session"
  exit 0
fi
if [[ $# -ne 0 ]]; then
  printf "z. Fuzzy search and launch a Zellij terminal workspace for a project.\n"
  printf "OTHER OPTIONS:\n"
  printf "  l            Lists all existing sessions, attaches when selecting\n"
  exit 0
fi
if [[ ! -f "$HOME/.project-dirs" ]]; then
  echo "z: ~/.project-dirs not found" >&2
  exit 1
fi

direct_dirs=()
parent_dirs=()
while IFS= read -r line; do
  [[ -z $line ]] && continue
  if [[ $line == =* ]]; then
    direct_dirs+=("${line#=}")
  else
    parent_dirs+=("$line")
  fi
done <"$HOME/.project-dirs"

output=""
if [[ ${#parent_dirs[@]} -gt 0 ]]; then
  output+="$(fd \
    --unrestricted \
    --absolute-path \
    --type d \
    --color=always \
    --min-depth 1 \
    --max-depth 1 \
    --exclude .git \
    . "${parent_dirs[@]}")"$'\n'
fi
if [[ ${#direct_dirs[@]} -gt 0 ]]; then
  output+="$(printf '%s\n' "${direct_dirs[@]}")"
fi

dir="$(echo "$output" | fzf)"

adjectives=(
  "adamant" "adept" "adventurous" "arcadian" "auspicious" "awesome"
  "blossoming" "brave" "charming" "chatty" "circular" "considerate"
  "cubic" "curious" "delighted" "didactic" "diligent" "effulgent"
  "erudite" "excellent" "exquisite" "fabulous" "fascinating" "friendly"
  "glowing" "gracious" "gregarious" "hopeful" "implacable" "inventive"
  "joyous" "judicious" "jumping" "kind" "likable" "loyal" "lucky"
  "marvellous" "mellifluous" "nautical" "oblong" "outstanding" "polished"
  "polite" "profound" "quadratic" "quiet" "rectangular" "remarkable"
  "rusty" "sensible" "sincere" "sparkling" "splendid" "stellar"
  "tenacious" "tremendous" "triangular" "undulating" "unflappable"
  "unique" "verdant" "vitreous" "wise" "zippy"
)
nouns=(
  "aardvark" "accordion" "apple" "apricot" "bee" "brachiosaur"
  "cactus" "capsicum" "clarinet" "cowbell" "crab" "cuckoo" "cymbal"
  "diplodocus" "donkey" "drum" "duck" "echidna" "elephant" "foxglove"
  "galaxy" "glockenspiel" "goose" "hill" "horse" "iguanadon" "jellyfish"
  "kangaroo" "lake" "lemon" "lemur" "magpie" "megalodon" "mountain"
  "mouse" "muskrat" "newt" "oboe" "ocelot" "orange" "panda" "peach"
  "pepper" "petunia" "pheasant" "piano" "pigeon" "platypus" "quasar"
  "rhinoceros" "river" "rustacean" "salamander" "sitar" "stegosaurus"
  "tambourine" "tiger" "tomato" "triceratops" "ukulele" "viola"
  "weasel" "xylophone" "yak" "zebra"
)

if [[ -n $dir ]]; then
  cd "$dir" || exit 1
  zellij \
    --session "$(basename "$dir")-${adjectives[RANDOM % ${#adjectives[@]}]}-${nouns[RANDOM % ${#nouns[@]}]}" \
    --new-session-with-layout project
fi
