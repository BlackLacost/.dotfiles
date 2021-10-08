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

alias vifm="$HOME/.config/vifm/scripts/vifmrun"
alias vim="nvim"

# ripgrep
alias rgf="rg --files | rg"

# Avoid duplicate bash history
export HISTCONTROL=ignoredups:erasedups

if [ -f $HOME/.webdavfs/secret ]; then
  source $HOME/.webdavfs/secret
fi

# fzf
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!{.git,node_modules,*.pyc}'"
export FZF_CTRL_T_COMMAND="rg -i --files --hidden --no-ignore-vcs --glob '!{.git,node_modules,*.pyc}'"
export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude '.git'"

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

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
