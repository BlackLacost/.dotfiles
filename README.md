# Dotfiles

## Fedora install

### Fast dnf

Проверить стоит ли флаг быстрых зеркал для dnf `sudo grep 'fastestmirror' /etc/dnf/dnf.conf`. Если не стоит то добавляем `sudo echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf`. После этого можно обновить кэш `sudo dnf clean all && sudo dnf makecache`.

Установить `sudo dnf install trash-cli` чтобы rm -rf удаляло в корзину.

Умный cd `sudo dnf install zoxide`.

Установить удобный runner, до этого нужно отключить у родного kRunner Alt+Space и включить у ulauncher `sudo dnf install ulauncher`. Включить как сервис `systemctl --user enable --now ulauncher`.

## Windows install

```shell
winget install --silent Microsoft.PowerShell
```

Relaunch terminal, continue with Elevated PowerShell:

```shell
$repo_url = "https://raw.githubusercontent.com/BlackLacost/.dotfiles"
$url = "$repo_url/main/configure_win.ps1"
# 'Invoke-Expression' instead of 'iex' since 'iex' is removed by profile.ps1
Invoke-WebRequest $url -OutFile ./configure.ps1
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
./configure.ps1
```

admin

```shell
$repo_url = "https://raw.githubusercontent.com/BlackLacost/.dotfiles"
$url = "$repo_url/main/win-init.ps1"
# 'Invoke-Expression' instead of 'iex' since 'iex' is removed by profile.ps1
Invoke-WebRequest $url -OutFile ./win-init.ps1
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
./win-init.ps1
Remove-Item ./win-init.ps1
```

user

```
gh auth login
gh repo clone .dotfiles $HOME\.dotfiles
cd $HOME\.dotfiles
Import-Module .\powershell\main.ps1
Update-WindowsConfiguration
```

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

## NixOS

```shell
sudo -i
systemctl start wpa_supplicant
wpa_cli
```

```wap_cli
add_network
set_network 0 ssid "RouteRich"
set_network 0 psk "password"
set_network 0 key_mgmt SAE # WPA 3
enable_network 0
quit
```

```shell
nix-shell -p git
git clone https://github.com/blacklacost/.dotfiles
sh .dotfiles/nixos/script.sh
nixos-install --flake /mnt/etc/nixos#nixos
reboot
# login like root
passwd ilya
reboot
```

## Manjaro

```shell
# dotfiles
# Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ln -sf ~/.dotfiles/home/.zshrc ~
# Tmux
sudo pamac install tmux
ln -sf ~/.dotfiles/home/.config/tmux/.tmux.conf ~
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
# Alacritty
ln -sfr ~/.dotfiles/home/.config/alacritty/ ~/.config
# проверить что в терминал поддерживает 256 цветов
tput colors
# Mpv player
sudo pamac install mpv
ln -sfr ~/.dotfiles/config/mpv/ ~/.config
# nvim
sudo pamac install neovim unzip luarocks ripgrep
git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
# MasonInstallAll
ln -sf ~/.dotfiles/home/.gitconfig ~
```

### Post manual install

```shell
### Установка yandex disk
sudo pamac build yandex-cloud-bin
sudo pamac build yandex-disk
yandex-disk setup
### Установка mailru
sudo pamac install rclone
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
