alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -vI"
alias mkd="mkdir -pv"

alias zshc="nvim ~/.zshrc"
alias zshs="source ~/.zshrc"
alias cdc="cd ~/code"
alias cddw="cd ~/Downloads/"
alias cddf="cd ~/.dotfiles/"
alias neobean='NVIM_APPNAME=linkarzu/dotfiles-latest/neovim/neobean nvim'

alias ohmyzsh="nvim ~/.oh-my-zsh"
alias dfe="nvim ~/.dotfiles/"
alias o='xdg-open'
alias lg='lazygit'
alias rcgm="rclone mount google: /home/ilya/cloud/google/ --vfs-cache-mode full --vfs-cache-max-size 200G --vfs-cache-poll-interval 5m --vfs-cache-max-age 168h --log-level INFO --log-file /tmp/rclone.log &"
alias rcgu="umount ~/cloud/google/"
alias rcmm="rclone mount mailru: /home/ilya/cloud/mailru --vfs-cache-mode full --vfs-cache-max-size 200G --vfs-cache-poll-interval 5m --vfs-cache-max-age 168h --log-level INFO --log-file /tmp/rclone.log &"
alias rcmu="umount ~/cloud/mailru/"
alias rcym="rclone mount yandexru: /home/ilya/cloud/yandexru --vfs-cache-mode full --vfs-cache-max-size 200G --vfs-cache-poll-interval 5m --vfs-cache-max-age 168h --log-level INFO --log-file /tmp/rclone.log &"
alias rcyu="umount ~/cloud/yandexru/"
alias rm="trash"

#alias gbc="git branch --show-current"

alias nvime="nvim ~/.config/nvim"
alias ghc='gh repo list | fzf | awk '\''{print $1}'\'' | xargs gh repo clone'
alias gghc='glgg --all | fzf | cut -d"'\''" -f2 | cut -d" " -f1 | tr -d "\n" | xsel -bi'
alias gcohc='git checkout `glgg --all | fzf | cut -d"'\''" -f2 | cut -d" " -f1 | tr -d "\n"`'

