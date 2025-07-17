# Stop on unhandled exceptions.
$ErrorActionPreference = "Stop";

Import-Module .\powershell\join-paths.psm1
Import-Module .\powershell\install-app;
Import-Module .\powershell\link-dotfiles;
Import-Module .\powershell\clone;
Import-Module .\powershell\default-directory;
Import-Module .\powershell\install-code-extension;
Import-Module .\powershell\configure-app;

function New-File() { New-Item -ItemType File -Force @args; }

function Get-PostConfigurationWindowsMessage {
  [CmdletBinding()]
  param ()

  Write-Host @"
      Config complete. Manual things to do
      - Install Disk-O
      - Pin trello to taskbar in Edge (not in Chrome due to wnd switch)
      - Pin term, vscode, web, double, pass, telegram, wino
      - Login and sync browser
"@;
}

function Test-HasCli {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [String] $Name
  )

  Get-Command $Name -ErrorAction SilentlyContinue;
  return $?;
}

function Install-PowershellModule {
  [CmdletBinding()]
  param (
    # Parameter help description
    [Parameter(Mandatory = $true)]
    [String]
    $ModuleName
  )

  Write-Host "Installing $ModuleName";
  if (Get-InstalledModule | Where-Object Name -eq $ModuleName) { return; }
  Install-Module $moduleName -Scope CurrentUser;
  if (-not $?) { throw "Failed" }
}



function Update-WindowsConfiguration {
  [CmdletBinding()]
  param ()

  # # Ensure at least 1.9 version for "add to path" manifest flag
  # & winget upgrade winget;

  Move-WindowDefaultDirectories;
  Update-AppConfig power;
  Update-AppConfig powershell;
  Update-AppConfig taskbar;

  # Write-Host "Configuration sudo as inline";
  # &sudo config --enable normal;
  Uninstall-App -Name "Microsoft.OneDrive";
  Uninstall-App -Name "Microsoft.Teams";
  Uninstall-App -Name "Copilot";

  Install-App 7zip;
  Install-App git;
  Install-App poshgit;
  Install-App gh;
  Clone dotfiles;
  New-LinkDotfiles gitconfig;
  Install-App code;
  Install-App jetbrainsfont;

  # & npm install -g diff-so-fancy # Better diff (require perl.exe)
  Install-App obsidian;
  Install-App powertoys;
  Install-App keepass;
  Install-App lsd;
  Install-App mpv;

  Install-App brave;
  Install-App telegram;
  Install-App qbittorrent;
  Install-App ollama;
  Install-App windirstat;
  Install-App winomail;
  Install-App processexplorer;
  Install-App obs;

  Get-PostConfigurationWindowsMessage;
}
