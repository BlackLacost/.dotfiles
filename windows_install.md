PowerShell

```powershell
New-Item -ItemType SymbolicLink -Path (Split-Path -Parent $PFOFILE) -Name "profile.ps" -Target .\profile.ps1
```

Windows Terminal

```powershell
New-Item -ItemType SymbolicLink -Path $HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState -Name settings.json -Target $HOME\.dotfiles\config\windows_terminal\settings.json
```
