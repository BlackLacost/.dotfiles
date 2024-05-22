# Dotfiles

## TODO

- code . работает некорректно в wsl, если vscode установлен через scoop.
- PIPENV_SKIP_LOCK=1,PIPENV_VENV_IN_PROJECT=1 для windows

## Установка

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
