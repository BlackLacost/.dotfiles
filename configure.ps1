Import-Module -Name "$PSScriptRoot\modules\InstallScoopApp.psm1"


class App {

  $_cfgDir = $null;

  Configure() {
    $this._cfgDir = "$($env:USERPROFILE)\.dotfiles";

    $this.InstallWindowsApps();
    $this.InstallPowershellModule("posh-git");
    $this.ConfigureVscode();
    $this.HardLinkModules();

    # Auto-created by PowerShell 5.x until 6.x+ is a system default.
    # Create and set hidden attribute to exclude from 'ls'.
    $oldPsDir = "$($env:USERPROFILE)\Documents\WindowsPowerShell";
    if (-not (Test-Path -Path $oldPsDir)) {
      $ret = & New-Item -Path $oldPsDir -ItemType Directory;
      $ret.Attributes = 'Hidden';
    }

    # PowerShell config is loaded from this dir.
    # Create and set hidden attribute to exclude from 'ls'.
    $psDir = "$($env:USERPROFILE)\Documents\PowerShell";
    if (-not (Test-Path -Path $psDir)) {
      $ret = & New-Item -Path $psDir -ItemType Directory;
      $ret.Attributes = 'Hidden';
    }

    # Symlink PowerShel config file into PowerShell config dir.
    $psProfileCfg = "$($this._cfgDir)/profile.ps1";
    if (-not (Test-Path -Path "$psDir/profile.ps1")) {
      New-Item `
        -ItemType HardLink `
        -Path $psDir `
        -Name "profile.ps1" `
        -Target $psProfileCfg `
        -Force
    }

    if (-not (Test-Path -Path ".editorconfig")) {
      $src = "$($this._cfgDir)/.editorconfig";
      Copy-Item -Path $src -Destination . -Force | Out-Null;
    }
  }

  hidden HardLinkModules() {
    $fullNameAndNameModules = Get-ChildItem .\modules\ | Select-Object FullName, Name, BaseName

    $fullNameAndNameModules | ForEach-Object {
      $profileDir = Split-Path -parent $profile;
      $moduleDir = Join-Path $profileDir "Modules" $_.BaseName;
      New-Item $moduleDir -ItemType Directory -Force;
      New-Item -ItemType HardLink -Path (Join-Path $moduleDir $_.Name) -Target $_.FullName -Force;
    }
  }

  hidden InstallWindowsApps() {
    Install-ScoopApp "sudo";
    Install-ScoopApp "anki";
    Install-ScoopApp "foxit-reader";
    Install-ScoopApp "googlechrome";
    Install-ScoopApp "git";
    Install-ScoopApp "miniconda3";
    Install-ScoopApp "Monoid-NF";
    Install-ScoopApp "rufus";
    Install-ScoopApp "smplayer";
    Install-ScoopApp "telegram";
    Install-ScoopApp "vscode";
    Install-ScoopApp "whatsapp";
    Install-ScoopApp "qbittorrent";
  }

  hidden ConfigureVscode() {
    Push-Location;
    Set-Location -Path $env:USERPROFILE

    $dstDir = "$($env:APPDATA)\Code\User";

    if (-not (Test-Path -Path $dstDir)) {
      New-Item -Path $dstDir -ItemType Directory | Out-Null;
    }

    $srcPath = "$($this._cfgDir)\vscode_settings.json";
    New-Item `
      -ItemType HardLink `
      -Path $dstDir `
      -Name "settings.json" `
      -Target $srcPath `
      -Force

    $srcPath = "$($this._cfgDir)\vscode_keybindings.json";
    New-Item `
      -ItemType HardLink `
      -Path $dstDir `
      -Name "keybindings.json" `
      -Target $srcPath `
      -Force

    Pop-Location;
  }

  hidden InstallPowershellModule($moduleName) {
    if (Get-InstalledModule | Where-Object Name -eq $moduleName) { return; }
    Install-Module $moduleName -Scope CurrentUser;
    if (-not $?) { throw "Failed" }
  }

}

$app = [App]::new();
$app.Configure();
