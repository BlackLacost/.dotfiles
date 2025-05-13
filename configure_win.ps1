# Stop on unhandled exceptions.
$ErrorActionPreference = "Stop";

Import-Module .\powershell\join-paths;
Import-Module .\powershell\install-app;
Import-Module .\powershell\link-dotfiles;
Import-Module .\powershell\clone;
Import-Module .\powershell\default-directory;
Import-Module .\powershell\install-code-extension;

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

function Has-Cli {
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


function  Set-PowerOptions() {
  Write-Host "Setting power policy";
  powercfg -change -monitor-timeout-ac 120;
  powercfg -change -monitor-timeout-dc 120;
  powercfg -change -disk-timeout-ac 0;
  powercfg -change -disk-timeout-dc 0;
  powercfg -change -standby-timeout-ac 0;
  powercfg -change -standby-timeout-dc 0;
  powercfg -change -hibernate-timeout-ac 0;
  powercfg -change -hibernate-timeout-dc 0;
  # Disable hibernate & delete hiberfil.sys
  powercfg -hibernate off
  #  Set 'plugged in' cooling policy to 'active'
  # powercfg -setacvalueindex scheme_current 54533251-82be-4824-96c1-47b60b740d00 94d3a615-a899-4ac5-ae2b-e4d8f634367f 1
  #  Set 'on battery' cooling policy to 'active'
  #! If set to 'passive' will downclock cpu to minimum, unusable
  # powercfg -setdcvalueindex scheme_current 54533251-82be-4824-96c1-47b60b740d00 94d3a615-a899-4ac5-ae2b-e4d8f634367f 1
}

function Configure-Windows {
  [CmdletBinding()]
  param ()

  Move-WindowDefaultDirectories;
  Set-PowerOptions;

  # # Ensure at least 1.9 version for "add to path" manifest flag
  # & winget upgrade winget;

  # Hide search in the taskbar
  $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
  Set-ItemProperty -Path $path -Name SearchboxTaskbarMode -Value 0;

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
  Link-Dotfiles gitconfig;
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
