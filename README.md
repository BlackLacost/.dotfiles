# Dotfiles

## TODO

- code . работает некорректно в wsl, если vscode установлен через scoop.
- PIPENV_SKIP_LOCK=1,PIPENV_VENV_IN_PROJECT=1 для windows

## Установка

- Install Windows Terminal via WindowsStore
- Disable python app execution alias
- Установить последний [PowerShell](https://github.com/PowerShell/PowerShell/releases) core через msi
- Если сайт 7zip блокируется, то надо настроить VPN

Запустить PowerShell core 7 под **админом**

```
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
Invoke-WebRequest -UseBasicParsing get.scoop.sh | Invoke-Expression
scoop install git
(Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/BlackLacost/.dotfiles/master/install.ps1).Content | Invoke-Expression
$d = New-Dotfiles
$d.Configure()
cd ~/.dotfiles
git reset --hard
```

- swap caps and ctrl using sharpkeys
- Установить Master PDF Editor

- poetry

```
(Invoke-WebRequest -Uri https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py -UseBasicParsing).Content | python -
poetry config virtualenvs.in-project true
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
