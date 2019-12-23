# Dotfiles

- Install Windows Terminal via WindowsStore
- Disable python app execution alias
- Если сайт 7zip блокируется, то надо настроить VPN

Windows PowerShell Admin
```
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
Invoke-WebRequest -UseBasicParsing get.scoop.sh | Invoke-Expression
scoop install pwsh
pwsh.exe
(Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/BlackLacost/.dotfiles/master/configure.ps1).Content | Invoke-Expression
```

Linux
```
sh link.sh
```
