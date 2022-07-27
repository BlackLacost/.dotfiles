#
# ~/.bashrc
#

echo "bashrc loading..."

#.profile
#  Load pyenv, if installed
if [ -d $HOME/.pyenv ]; then
  export PYENV_ROOT=$HOME/.pyenv/
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# Pipenv auto completion
#eval "$(pipenv --completion)"

# Always install dependencies in .venv for pipenv.
export PIPENV_VENV_IN_PROJECT="1"
# Do not lock dependencies (very slow).
export PIPENV_SKIP_LOCK="1"

export TERM=alacritty
export VISUAL=nvim
export EDITOR=nvim
export BROWSER=firefox
export READER="zathura"

##  256-colors in terminal for apps that knows how to use it.
# export TERM=xterm-256color

# Adds `~/.local/bin` to $PATH
#export PATH="$PATH:$(find "$HOME/.local/bin/" -type d | tr '\n' ':' | sed 's/:*$//')"

### end profile

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
echo "bashrc interactively loading..."

mkcd() { mkdir -p "$@" && cd "$@"; }

alias ls='exa --group-directories-first --classify --sort=extension --icons'
alias ll='exa --group-directories-first \
              --long \
              --classify \
              --grid \
              --links \
              --header \
              --git \
              --sort=extension \
              --icons'
alias lsa='ls --all'
alias lla='ll --all'
alias lt='exa --tree --level=2 --classify --sort=ext --icons'
alias nnn="nnn -e"
alias g=git
alias glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glga="glg --all"
alias gcmm='git commit -m'
alias gcma='git commit --amend'
alias gsw='git switch'
alias gchb='git checkout -b'
alias gst='git status'
alias gdf='git diff'
alias gdfc='git diff --cached'
alias cdd='cd ~/.dotfiles'
alias cdx='cd ~/.xi'
alias cdc='cd ~/code'
alias cdl='cd ~/cloud/mailru/G.Prog'
alias vec="python -m venv .venv"
alias vea=". .venv/bin/activate"
alias ved="deactivate"
alias vifm="$HOME/.config/vifm/scripts/vifmrun"
alias vim="nvim"
alias v="nvim"
alias rgf="rg --files | rg"
alias ghc='gh repo clone `gh repo list --limit=1000 | awk '"'"'{ print $1 }'"'"' | fzf`'
alias vpnu='wg-quick up ~/vpn.conf'
alias vpnd='wg-quick down ~/vpn.conf'

# colors
# export TERM=xterm-24bit


# Avoid duplicate bash history
export HISTCONTROL=ignoredups:erasedups


if [ -f $HOME/.webdavfs/secret ]; then
  source $HOME/.webdavfs/secret
fi

# fzf
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

# git
source /usr/share/git/completion/git-completion.bash

# fzf
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!{.git,node_modules,*.pyc}'"
export FZF_CTRL_T_COMMAND="rg -i --files --hidden --no-ignore-vcs --glob '!{.git,node_modules,*.pyc}'"
export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude '.git'"
#FD_OPTIONS="--hidden \
#            --exclude .git \
#            --exclude node_modules \
#            --exclude .npm \
#            --exclude .nvm"
#export FZF_DEFAULT_OPTS='--height 100% --layout=reverse --border'
#export FZF_DEFAULT_COMMAND="fd --type f --type l $FD_OPTIONS"
#export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"

# git
source /usr/share/git/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
# export GIT_PS1_SHOWUPSTREAM="verbose name"
export GIT_PS1_SHOWUPSTREAM="auto"
RED="$(echo -e "\e[31m")"
GREEN="$(echo -e "\e[32m")"
YELLOW="$(echo -e "\e[33m")"
BLUE="$(echo -e "\e[34m")"
MAGENTA="$(echo -e "\e[35m")"
RESET="$(echo -e "\e[00m")"
# PS1='\[${MAGENTA}\][\w]\[${RESET}\] \[${BLUE}\]$(__git_ps1 "(%s)")\[${RESET}\] \n\[${GREEN}\]\$\u\[${RESET}\] -> '
PS1='\[${MAGENTA}\]\W\[${RESET}\]$(__git_ps1 "\[${GREEN}\] (%s)\[${RESET}\]") -> '
PS2='-> '


function ss() {
  $BROWSER https://www.google.com/search?q=`echo $* | jq -sRr @uri`
}



[ -f ~/.fzf.bash ] && source ~/.fzf.bash
