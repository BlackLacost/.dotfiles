# vscode-config

Установить monoid шрифты.

Папка с настройками:
- **Windows** ```%APPDATA%\Code\User\```
- **Linux** ```$HOME/.config/Code/User/settings.json```

Windows for user "User"
```
cp .\vscode_settings.json C:\Users\User\AppData\Roaming\Code\User\settings.json
cp .\vscode_settings.json C:\Users\User\AppData\Roaming\Code\User\keybindings.json
```

Linux
```
$ ln vscode_keybindings.json ~/.config/Code/User/keybindings.json 
$ ln vscode_settings.json ~/.config/Code/User/settings.json
```
