# Dotfiles

## TODO

- code . работает некорректно в wsl, если vscode установлен через scoop.

## Установка

- Install Windows Terminal via WindowsStore
- Disable python app execution alias
- Установить последный [PowerShell](https://github.com/PowerShell/PowerShell/releases) core через msi
- Если сайт 7zip блокируется, то надо настроить VPN

Запустить PowerShell core 7 под **админом**

```
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
Invoke-WebRequest -UseBasicParsing get.scoop.sh | Invoke-Expression
scoop install git
(Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/BlackLacost/.dotfiles/master/install.ps1).Content | Invoke-Expression
$d = New-Dotfiles
$d.Configure()
```

- swap caps and ctrl using sharpkeys
- Установить Master PDF Editor

WSL

Установить:

ArchWSL

Установка pyenv

```
curl https://pyenv.run | bash
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
