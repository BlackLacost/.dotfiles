#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Adds `~/.local/bin` to $PATH
export PATH="$PATH:`find ~/.local/bin -type d -printf %p:`"

PS1='[\u@\h \W]\$ '
source /usr/share/nvm/init-nvm.sh

# Enable vim-mode
set -o vi
set show-mode-in-prompt on

# Avoid duplicate bash history
export HISTCONTROL=ignoredups:erasedups

# Add chrome.exe in windows PATH
# Install wslview
export BROWSER='chrome.exe'

export EDITOR='nvim'

mkcd() { mkdir -p "$@" && cd "$@"; }

alias ls='ls --color=auto'
alias ll='ls -la --color=auto'

alias g=git
alias glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glga="git log --all --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gcmm='git commit -m'
alias gcma='git commit --amend'
alias gsw='git switch'
alias gchb='git checkout -b'
alias gst='git status'
alias gdf='git diff'
alias gdfc='git diff --cached'

alias cdd='cd ~/.dotfiles'
alias cdp='cd ~/code'

alias dokku='$HOME/.dokku/contrib/dokku_client.sh'
alias v='nvim'

alias ghc='gh repo clone `gh repo list --limit=1000 | awk '"'"'{ print $1 }'"'"' | fzf`'

function ss() {
  $BROWSER https://www.google.com/search?q=`echo $* | jq -sRr @uri`
}

source ~/.private

eval "$(oh-my-posh --init --shell bash --config ~/.poshthemes/star.omp.json)"

