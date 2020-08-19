#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias g=git
alias ggl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

alias cdd='cd ~/.dotfiles'
alias cdx='cd ~/.xi'
alias cdc='cd ~/code'

## python virtual environment
alias vec="python -m venv .venv"
alias vea=". .venv/bin/activate"
alias ved="deactivate"

##  256-colors in terminal for apps that knows how to use it.
export TERM=xterm-256color

export EDITOR="code"

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
# PS1='\[${MAGENTA}\][\w]\[${RESET}\] \[${BLUE}\]$(__git_ps1 "(%s)")\[${RESET}\] \n\[${GREEN}\]\$\u\[${RESET}\] ➡️  '
PS1='\[${MAGENTA}\]\W\[${RESET}\]$(__git_ps1 "\[${GREEN}\] (%s)\[${RESET}\]") ➡️  '
PS2='↪️️  '

##* Usefull for npm tools that are not installed globally
export PATH=$PATH:./node_modules/.bin

##  Load pyenv, if installed
if [ -d $HOME/.pyenv ]; then
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# Always install dependencies in .venv for pipenv.
export PIPENV_VENV_IN_PROJECT="1"
# Do not lock dependencies (very slow).
export PIPENV_SKIP_LOCK="1"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
