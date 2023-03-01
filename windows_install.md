PowerShell

```powershell
New-Item -ItemType SymbolicLink -Path (Split-Path -Parent $PFOFILE) -Name "profile.ps" -Target .\profile.ps1
```

Windows Terminal

```powershell
New-Item -ItemType SymbolicLink -Path $HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState -Name settings.json -Target $HOME\.dotfiles\config\windows_terminal\settings.json
```

VSCode

```powershell
New-Item -ItemType Junction -Path $env:APPDATA\Code\User\snippets -Target $HOME\.dotfiles\config\vscode\snippets -Force
New-Item -ItemType SymbolicLink -Path $env:APPDATA\Code\User -Name settings.json -Target $HOME\.dotfiles\config\vscode\settings.json -Force
New-Item -ItemType SymbolicLink -Path $env:APPDATA\Code\User -Name keybindings.json -Target $HOME\.dotfiles\config\vscode\keybindings.json -Force
```

MPV

```powershell
New-Item -ItemType Junction -Path $HOME\scoop\apps\mpv\current\portable_config -Target $HOME\.dotfiles\config\mpv -Force
```
