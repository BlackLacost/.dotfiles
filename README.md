# Dotfiles

## Manjaro

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ln -sf ~/.dotfiles/home/.zshrc ~
# autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# highlight commands in terminal
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# helper to remember aliases
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use
# better version of cat
sudo pamac install bat
# replace cat by bat in zsh
git clone https://github.com/fdellwing/zsh-bat.git $ZSH_CUSTOM/plugins/zsh-bat
ln -sfr ~/.dotfiles/config/mpv/ ~/.config
```

### Post manual install

```shell
### Установка yandex disk
sudo pamac build yandex-cloud-bin
sudo pamac build yandex-disk
yandex-disk setup
### Установка mailru
sudo pamac -S rclone
rclone config
# n) New remote
# mailru
# 29
# client_id>
# client_secret>
# user> blacklacost@inbox.ru
# y) Yes, type in my own password
# all default values
mkdir -p ~/.config/systemd/user
ln -sf ~/.dotfiles/home/.config/systemd/user/rclone@mailru.service ~/.config/systemd/user
systemctl --user start rclone@mailru
systemctl --user enable rclone@mailru
### Решение проблемы со sleep в linux с systemd для b650
# Посмотреть какие девайсы могут включить комп
# cat /proc/acpi/wakeup
# Работает как toggle
# echo "XH00" | sudo tee /proc/acpi/wakeup
sudo mkdir -p /etc/systemd/system
sudo ln -sf ~/.dotfiles/home/.config/systemd/system/fix-suspense.service /etc/systemd/system
sudo systemctl start fix-suspense.service
sudo systemctl enable fix-suspense.service
```

## Установка Windows

- Install Windows Terminal via WindowsStore
- PowerToys

[WSL](https://docs.microsoft.com/ru-ru/windows/wsl/install-win10#manual-installation-steps)

Установить:

ArchWSL

```
scoop bucket add extras
scoop install archwsl
```

[PostInstall](https://wsldl-pg.github.io/ArchW-docs/How-to-Setup/#setup-after-install)

Установка pyenv

```
curl https://pyenv.run | bash
pacman -S base-devel openssl zlib
pyenv install --list
pyenv install <version>
```

Установка nvm

```
cd ~
git clone https://github.com/nvm-sh/nvm.git .nvm
```

Установка wslu (wslview)

Download the latest package from [release](https://github.com/wslutilities/wslu/releases) and install using the command: `sudo pacman -U *.zst`

настроить ssh

```
sh link.sh
git clone git@github.com:BlackLacost/.xi.git
```

Backup wsl linux и восстановление.

```
wsl --export Arch ./archwsl.tar

mkdir ~/AppData/Local/MyDistro
wsl --import Arch ~/AppData/Local/MyDistro ./archwsl.tar --version 2
```

Поддержка powerline fonts для vim airlines

```
sudo pacman -S powerline-fonts
```

Установка crt сертификатов в wsl Ubuntu

```shell
sudo mkdir /usr/share/ca-certificates/<name-organization>
sudo sudo <sert-name> /usr/share/ca-certificates/<name-organization>/
sudo dpkg-reconfigure ca-certificates
```

```powershell
wsl --shutdown
```
