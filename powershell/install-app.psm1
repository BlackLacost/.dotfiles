Import-Module .\powershell\env-path;
Import-Module .\powershell\link-dotfiles;
Import-Module .\powershell\install-code-extension.psm1;

function New-SoftlinkDir() { New-Item -ItemType Junction -Force @args; }

function Check-GitHubCliAuth {
  [CmdletBinding()]
  param ()

  if (-not (Check-AppInstalled -Name Github.cli)) {
    Write-Verbose "GitHub CLI not installed"
    return $false
  }
  &gh auth status *> $null;

  if ($LASTEXITCODE -eq 0) {
    Write-Verbose "GitHub CLI is auth"
    return $true;
  }
  else {
    Write-Verbose "GitHub CLI is not auth"
    return $false;
  }
}

function Check-AppInstalled {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string]$Name
  )

  Write-Verbose "Checking if app '$Name' is installed via winget..."

  & winget list "$Name" *>$null

  if ($LASTEXITCODE -eq 0) {
    return $true
  }
  else {
    return $false
  }
}

# TODO: Установка в папку пользователя
function Auth-GitHubCli {
  [CmdletBinding()]
  param ()

  if (-not (Check-GitHubCliAuth)) {
    Write-Host "Auth to GitHub";
    &gh auth login;
  }
  else {
    Write-Host "Already authenticated"
  }
}

function Configure-NVM {
  [CmdletBinding()]
  param ()

  & nvm install lts;
  Write-Host "nvm install last lts version";
  & nvm use lts;
  Write-Host "Updating npm"
  & npm install -g npm@latest
}

function Configure-Vscode() {
  [CmdletBinding()]
  param()
  Link-Dotfiles code;

  Install-CodeExtension continue;
  Install-CodeExtension memory-theme;
  # Install-VscodeExt grigoryvp.language-xi";
  # Install-VscodeExt grigoryvp.goto-link-provider";
  # Install-VscodeExt grigoryvp.markdown-python-repl-syntax";
  # Install-VscodeExt grigoryvp.markdown-pandoc-rawattr";
  # Install-VscodeExt EditorConfig.EditorConfig";
  Install-CodeExtension vscodevim;
  Install-CodeExtension markdown-inline-fence;
  Install-CodeExtension material-icon-theme;

  Install-CodeExtension angular-console;
  Install-CodeExtension prettier-vscode
  Install-CodeExtension prettier-eslint;
  Install-CodeExtension css-modules;
  Install-CodeExtension css-modules-highlights;
  Install-CodeExtension tailwindcss;
  Install-CodeExtension pretty-ts-errors;
  Install-CodeExtension thunder-client;
  Install-CodeExtension auto-close-tag;
  Install-CodeExtension powershell;
  Install-CodeExtension project-manager;
  Install-CodeExtension todo-tree;
  Install-CodeExtension event-better-toml;
  Install-CodeExtension yaml;
  # # Wrap all comments by Alt+Q or Ctrl+Q
  # $this._installVscodeExt("dnut.rewrap-revived");
  # $this._installVscodeExt("streetsidesoftware.code-spell-checker");
  # $this._installVscodeExt("streetsidesoftware.code-spell-checker-russian");
  # # $this._installVscodeExt("mark-wiemer.vscode-autohotkey-plus-plus");

  #     $docCfgDir = $this._path(@("~", "Documents", ".vscode"));
  #     if (-not (Test-Path -Path "$docCfgDir")) {
  #       New-Dir -Path "$docCfgDir";
  #     }

  #     $content = @'
  #       {
  #         "files.exclude": {
  #           "My Music/": true,
  #           "My Pictures/": true,
  #           "My Videos/": true,
  #           "My Games/": true,
  #           "Sound Recordings/": true,
  #           "Diablo IV/": true,
  #           "PowerShell": true,
  #           "WindowsPowerShell": true,
  #           "desktop.ini": true,
  #           ".vscode/": true
  #         }
  #       }
  # '@;

  #     New-File -Path $docCfgDir -Name "settings.json" -Value "$content";

  ##  Exclude from 'ls'.
  # $(Get-Item -Force $docCfgDir).Attributes = 'Hidden';
}

function Configure-Powershell {
  [CmdletBinding()]
  param ()

  # Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted;
  # Install-PowershellModule -ModuleName "WindowsCompatibility";
  # Symlink PowerShel config file into PowerShell config dir.
  Link-Dotfiles powershell;
}

function Configure-Lsd {
  [CmdletBinding()]
  param ()

  Link-Dotfiles lsd;
}

function Configure-Ollama {
  [CmdletBinding()]
  param ()

  $ollamaDir = "D:\.ollama";
  Write-Host $ollamaDir;
  if (-not (Test-Path -Path $ollamaDir)) {
    Write-Host "Create ollama dir $ollamaDir";
    New-Dir -Path $ollamaDir;
  }
  $newOllamaDir = Join-Path -Path $HOME -ChildPath .ollama;
  if (Test-Path -Path $newOllamaDir) {
    Write-Host "Remove ollama dir $newOllamaDir";
    Remove-Item $newOllamaDir -Force -Recurse;
  }
  New-SoftlinkDir -Path $newOllamaDir -Target $ollamaDir;
}

function Install-WingetApp {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [String] $Name,

    [Parameter()]
    [String] $EnvPath
  )

  if (Check-AppInstalled -Name $Name) {
    Write-Verbose "$Name is already installed"
    return
  }

  Write-Host "Installing $Name..."
  & winget install --silent --accept-package-agreements $Name
  if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to install $Name"
    return
  }

  if ($PSBoundParameters.ContainsKey('EnvPath')) {
    Add-EnvPath -Path $EnvPath -Target Machine;
  }
  else {
    Write-Verbose "Параметр EnvPath не был передан"
  }
}

function Install-App {
  [CmdletBinding()]
  param (
    [ValidateSet(
      '7zip',
      'brave',
      'code',
      'jetbrainsfont',
      'git',
      'gh',
      'keepass',
      'lsd',
      'mpv',
      'nvm',
      'ollama',
      'obs',
      'obsidian',
      'poshgit',
      'powertoys',
      'processexplorer',
      'telegram',
      'qbittorrent',
      'windirstat',
      'winomail'
    )]
    [String] $Name
  )

  switch ($Name) {
    '7zip' {
      Install-WingetApp -Name "7zip.7zip";

    }
    'brave' {
      Install-WingetApp -Name "Brave.Brave";
    }
    'code' {
      Install-WingetApp -Name "Microsoft.VisualStudioCode";
      Configure-Vscode;
    }
    'jetbrainsfont' {
      Install-WingetApp -Name "DEVCOM.JetBrainsMonoNerdFont";
    }
    'git' {
      Install-WingetApp -Name "Git.Git";
    }
    'gh' {
      Install-WingetApp -Name "Github.cli" -EnvPath "C:\Program Files\GitHub CLI";
      Auth-GitHubCli;
    }
    'keepass' {
      Install-WingetApp -Name "KeePassXCTeam.KeePassXC";
    }
    'lsd' {
      Install-WingetApp -Name "lsd-rs.lsd";
      Configure-Lsd;
    }
    'mpv' {
      Install-WingetApp -Name "mpv.net";
      Link-Dotfiles mpv;
    }
    'nvm' {
      Install-WingetApp -Name "CoreyButler.NVMforWindows" -EnvPath $(Join-Path -Path $env:LOCALAPPDATA -ChildPath "nvm");
      Configure-NVM;
    }
    'obs' {
      Install-WingetApp -Name "OBSProject.OBSStudio";
    }
    'obsidian' {
      Install-WingetApp -Name "Obsidian.Obsidian";
      Clone pkm;
      Clone obsidian-review-plugin;
    }
    'ollama' {
      Install-WingetApp -Name "Ollama.Ollama";
      Configure-Ollama;
    }
    'poshgit' {
      Install-PowershellModule -ModuleName "posh-git";
    }
    'powertoys' {
      Install-WingetApp -Name "Microsoft.PowerToys";
    }
    'processexplorer' {
      Install-WingetApp -Name "Microsoft.Sysinternals.ProcessExplorer"; # Better process maangement
    }
    'telegram' {
      Install-WingetApp -Name "Telegram.TelegramDesktop";
    }
    'qbittorrent' {
      Install-WingetApp -Name "qBittorrent.qBittorrent";
    }
    'windirstat' {
      Install-WingetApp -Name "WinDirStat.WinDirStat"; # Folder size analyzer;
    }
    'winomail' {
      Install-WingetApp -Name "9NCRCVJC50WL";
    }
    Default {}
  }
}

function Uninstall-App {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [String] $Name
  )

  if (-not (Check-AppInstalled -Name $Name)) {
    Write-Verbose "$Name is already uninstalled"
    return
  }

  Write-Host "Uninstalling $Name..."
  & winget uninstall --silent $Name
  if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to uninstall $Name"
    return
  }
}

Export-ModuleMember -Function Install-App, Uninstall-App, Check-AppInstalled, Check-GitHubCliAuth;