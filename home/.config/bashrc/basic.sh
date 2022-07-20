### Basic

# Avoid duplicate bash history
export HISTCONTROL=ignoredups:erasedups

mkcd() { mkdir -p "$@" && cd "$@"; }
alias ghc='gh repo clone `gh repo list --limit=1000 | awk '"'"'{ print $1 }'"'"' | fzf`'

function ss() {
  $BROWSER https://www.google.com/search?q=`echo $* | jq -sRr @uri`
}
