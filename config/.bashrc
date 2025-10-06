echo "bashrc..."

#.profile
export TERM=alacritty
export VISUAL=nvim
export EDITOR=nvim
export READER="zathura"
export BROWSER=google-chrome-stable
# xdg-settings set default-web-browser google-chrome-stable.desktop
# xdg-mime default google-chrome.desktop x-scheme-handler/http
# xdg-mime default google-chrome.desktop x-scheme-handler/https

##  256-colors in terminal for apps that knows how to use it.
# export TERM=xterm-256color

# Adds `~/.local/bin` to $PATH
#export PATH="$PATH:$(find "$HOME/.local/bin/" -type d | tr '\n' ':' | sed 's/:*$//')"

### end profile

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
echo "bashrc interactively loading..."

mkcd() { mkdir -p "$@" && cd "$@"; }

# colors
# export TERM=xterm-24bit

# Avoid duplicate bash history
export HISTCONTROL=ignoredups:erasedups

if [ -f ~/.config/aliasrc ]; then
  source ~/.config/aliasrc
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/bashrc.post.bash" ]] && builtin source "$HOME/.fig/shell/bashrc.post.bash"
