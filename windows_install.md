PowerShell

сначала устоновить powershell 7

```powershell
New-Item -ItemType SymbolicLink -Path (Split-Path -Parent $PROFILE) -Name "profile.ps" -Target $HOME\.dotfiles\profile.ps1
```

Windows Terminal

```powershell
New-Item -ItemType SymbolicLink -Path $HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState -Name settings.json -Target $HOME\.dotfiles\config\windows_terminal\settings.json
```

MPV

```powershell
sudo New-Item -ItemType Junction -Path $HOME\scoop\apps\mpv\current\portable_config -Target $HOME\.dotfiles\config\mpv -Force
```

Git

```powershell
sudo New-Item -ItemType SymbolicLink -Path C:\Users\black\.gitconfig -Target $HOME\.dotfiles\config\git\.gitconfig -Force
```

WSL

```powershell
sudo powershell New-Item -ItemType SymbolicLink -Path C:\Users\black\.wslconfig -Target C:\Users\black\.dotfiles\config\wsl\.wslconfig
```
