Import-Module .\powershell\env-path;
Import-Module .\powershell\link-dotfiles;
Import-Module .\powershell\install-code-extension.psm1;
Import-Module .\powershell\configure-app;

function New-SoftlinkDir() { New-Item -ItemType Junction -Force @args; }

function Test-GitHubCliAuth {
  [CmdletBinding()]
  param ()

  if (-not (Test-AppInstalled -Name Github.cli)) {
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

function Test-AppInstalled {
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


function Install-WingetApp {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [String] $Name,

    [Parameter()]
    [String] $EnvPath
  )

  if (Test-AppInstalled -Name $Name) {
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
    [String] $Name,

    [Parameter(Mandatory = $false)]
    [Boolean] $WithConfig = $true
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
      if ($WithConfig) { Update-AppConfig code; }
    }
    'jetbrainsfont' {
      Install-WingetApp -Name "DEVCOM.JetBrainsMonoNerdFont";
    }
    'git' {
      Install-WingetApp -Name "Git.Git";
    }
    'gh' {
      Install-WingetApp -Name "Github.cli" -EnvPath "C:\Program Files\GitHub CLI";
      if ($WithConfig) { Update-AppConfig gh; }
    }
    'keepass' {
      Install-WingetApp -Name "KeePassXCTeam.KeePassXC";
    }
    'lsd' {
      Install-WingetApp -Name "lsd-rs.lsd";
      if ($WithConfig) { New-LinkDotfiles lsd; }
    }
    'mpv' {
      Install-WingetApp -Name "mpv.net";
      if ($WithConfig) { New-LinkDotfiles mpv; }
    }
    'nvm' {
      Install-WingetApp -Name "CoreyButler.NVMforWindows" -EnvPath $(Join-Path -Path $env:LOCALAPPDATA -ChildPath "nvm");
      if ($WithConfig) { Update-AppConfig nvm; }
    }
    'obs' {
      Install-WingetApp -Name "OBSProject.OBSStudio";
    }
    'obsidian' {
      Install-WingetApp -Name "Obsidian.Obsidian";
      if ($WithConfig) {
        Clone pkm;
        Clone obsidian-review-plugin;
      }
    }
    'ollama' {
      Install-WingetApp "Ollama.Ollama";

      if ($WithConfig) { Update-AppConfig ollama; }
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

  if (-not (Test-AppInstalled -Name $Name)) {
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

function Test-WingetAppInstalled {
  [CmdletBinding()]
  param([ValidateSet('telegram', 'qbittorrent')] [String] $Name)

  Write-Verbose "Checking if app '$Name' is installed via winget..."

  $WingetId = Get-WingetId -Name $Name;
  & winget list "$WingetId" *>$null

  return ($LASTEXITCODE -eq 0)
}


function Get-WingetId {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('telegram', 'qbittorrent')]
    [String] $Name)

  switch ($Name) {
    'telegram' { return "Telegram.TelegramDesktop" }
    'qbittorrent' { return "qBittorrent.qBittorrent" }
    Default { throw "Unknown application name: $Name" }
  }
}


Export-ModuleMember -Function Install-App, Uninstall-App, Test-AppInstalled, Test-GitHubCliAuth, Get-WingetId, Test-WingetAppInstalled
