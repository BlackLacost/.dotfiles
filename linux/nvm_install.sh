if ! yay -Qq nvm-git &> /dev/null; then
  yay -S nvm-git #  --noconfirm
fi

if ! grep -qF "source /usr/share/nvm/init-nvm.sh" ~/.bashrc; then
  echo "source /usr/share/nvm/init-nvm.sh" >> ~/.bashrc
fi

# TODO: Install lts and use
# source ~/.bashrc
# nvm install --lts
# nvm use --lts
