#!/bin/sh

# Adds `~/.local/bin` to $PATH
export PATH="$PATH:$(find "$HOME/.local/bin/" -type d | tr '\n' ':' | sed 's/:*$//')"

# Usefull for npm tools that are not installed globally
export PATH=$PATH:./node_modules/.bin

# Default programs:
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="brave"
export READER="zathura"

##  256-colors in terminal for apps that knows how to use it.
export TERM=xterm-256color

# fzf
FD_OPTIONS="--hidden \
            --exclude .git \
            --exclude node_modules \
            --exclude .npm \
            --exclude .nvm"
export FZF_DEFAULT_OPTS='--height 100% --layout=reverse --border'
export FZF_DEFAULT_COMMAND="fd --type f --type l $FD_OPTIONS"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"

# Other program settings:
export SUDO_ASKPASS="$HOME/.local/bin/dmenupass"

#  Load pyenv, if installed
if [ -d $HOME/.pyenv ]; then
  export PYENV_ROOT=$HOME/.pyenv/
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# Pipenv auto completion
eval "$(pipenv --completion)"

# Always install dependencies in .venv for pipenv.
export PIPENV_VENV_IN_PROJECT="1"
# Do not lock dependencies (very slow).
export PIPENV_SKIP_LOCK="1"

# Django auto completion
. ~/.config/django/django_bash_completion.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

startx
