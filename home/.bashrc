echo "bashrc..."

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
#export PIPENV_VENV_IN_PROJECT="1"
# Do not lock dependencies (very slow).
#export PIPENV_SKIP_LOCK="1"

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

function gs() {
  $BROWSER https://www.google.com/search?q=`echo $* | jq -sRr @uri`
}

function ys() {
  $BROWSER https://www.ya.ru/search?text=`echo $* | jq -sRr @uri`
}


if [ -f ~/opt/asdf-vim/asdf.sh ]; then
  source /opt/asdf-vm/asdf.sh
fi

if [ -f ~/.config/aliasrc ]; then
  source ~/.config/aliasrc
fi


[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/bashrc.post.bash" ]] && builtin source "$HOME/.fig/shell/bashrc.post.bash"
