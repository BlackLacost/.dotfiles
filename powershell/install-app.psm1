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
    [String] $EnvPath,

    [Parameter()]
    [String] $Location
  )

  if (Test-AppInstalled -Name $Name) {
    Write-Verbose "$Name is already installed"
    return
  }

  Write-Host "Installing $Name..."
  & winget install --silent --accept-package-agreements $Name $($Location ? "--location $Location" : "")

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
      'winomail',
      'zip'
    )]
    [String] $Name,

    [Parameter()]
    [Boolean] $WithConfig = $true
  )

  Install-WingetApp -Name $(Get-AppConfig -Name $Name -Field wingetId)

  if ($WithConfig) {
    Update-AppConfig -Name $Name;
  }

  # switch ($Name) {
  #   'lsd' {
  #     Install-WingetApp -Name "lsd-rs.lsd";
  #     if ($WithConfig) { New-LinkDotfiles lsd; }
  #   }
  #   'mpv' {
  #     Install-WingetApp -Name "mpv.net";
  #     if ($WithConfig) { New-LinkDotfiles mpv; }
  #   }
  #   'nvm' {
  #     Install-WingetApp -Name "CoreyButler.NVMforWindows" -EnvPath $(Join-Path -Path $env:LOCALAPPDATA -ChildPath "nvm");
  #     if ($WithConfig) { Update-AppConfig nvm; }
  #   }
  #   'obs' {
  #     Install-WingetApp -Name "OBSProject.OBSStudio";
  #   }
  #   'obsidian' {
  #     Install-WingetApp -Name "Obsidian.Obsidian";
  #     if ($WithConfig) {
  #       Clone pkm;
  #       Clone obsidian-review-plugin;
  #     }
  #   }
  #   'ollama' {
  #     Install-WingetApp "Ollama.Ollama";

  #     if ($WithConfig) { Update-AppConfig ollama; }
  #   }
  #   'poshgit' {
  #     Install-PowershellModule -ModuleName "posh-git";
  #   }
  #   'powertoys' {
  #     Install-WingetApp -Name "Microsoft.PowerToys";
  #   }
  #   'processexplorer' {
  #     Install-WingetApp -Name "Microsoft.Sysinternals.ProcessExplorer"; # Better process maangement
  #   }
  #   'telegram' {
  #     Install-WingetApp -Name "Telegram.TelegramDesktop";
  #   }
  #   'qbittorrent' {
  #     Install-WingetApp -Name $(Get-AppConfig -Name qbittorrent -Field wingetId)
  #   }
  #   'windirstat' {
  #     Install-WingetApp -Name "WinDirStat.WinDirStat"; # Folder size analyzer;
  #   }
  #   'winomail' {
  #     Install-WingetApp -Name "9NCRCVJC50WL";
  #   }
  #   Default {}
  # }
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
  param([ValidateSet('keepass', 'telegram', 'qbittorrent')] [String] $Name)

  Write-Verbose "Checking if app '$Name' is installed via winget..."
  & winget list $(Get-AppConfig $Name wingetId) *>$null
  return ($LASTEXITCODE -eq 0)
}

function Get-AppConfig {
  [CmdletBinding()]
  [OutputType([Hashtable])]
  param(
    [Parameter(Mandatory = $true)]
    [ValidateSet(
      'brave',
      'code',
      'gh',
      'jetbrainsfont',
      'keepass',
      'telegram',
      'qbittorrent',
      'zip'
    )]
    [String] $Name,

    [ValidateSet(
      'wingetId',
      'location',
      'path',
      'envType'
    )]
    [String] $Field
  )

  $AppConfig = @{
    brave = @{
      wingetId = "Brave.Brave"
      location = $null
      path     = $null
      envType  = $null
    }
    code = @{
      wingetId = "Microsoft.VisualStudioCode"
      location = $null
      path     = $null
      envType  = $null
    }
    gh = @{
      wingetId = "Github.cli"
      location = $null
      path     = "C:\Program Files\GitHub CLI"
      envType  = "Machine"
    }
    jetbrainsfont = @{
      wingetId = "DEVCOM.JetBrainsMonoNerdFont"
      location = $null
      path     = $null
      envType  = $null
    }
    keepass = @{
      wingetId = "KeePassXCTeam.KeePassXC"
      location = "$HOME\apps\keepassxc"
      path     = "$HOME\apps\keepassxc"
      envType  = "User"
    }
    poshgit = @{

    }
    wingetId = $null
    powerShell
    #     Install-PowershellModule -ModuleName "posh-git";
    location = $null
    path = $null
    envType = $null
    telegram = @{
      wingetId = "Telegram.TelegramDesktop"
      location = $null
      path = $null
      envType = $null
    }
    qbittorrent   = @{
      wingetId = "qBittorrent.qBittorrent"
      location = $null
      path     = $null
      envType  = $null
    }
    zip           = @{
      wingetId = "7zip.7zip"
      location = $null
      path     = $null
      envType  = $null

    }
  }

  if ($PSBoundParameters.ContainsKey('Field')) {
    return $AppConfig[$Name][$Field]
  }

  return $AppConfig[$Name]
}

Export-ModuleMember -Function Install-App, Uninstall-App, Test-AppInstalled, Test-GitHubCliAuth, Test-WingetAppInstalled, Get-AppConfig;
