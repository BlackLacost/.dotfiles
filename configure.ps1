Import-Module -Name "$PSScriptRoot\modules\InstallScoopApp.psm1"


class App {

  $_cfgDir = $null;
  $_windowsDirConfigs = @{
    "editorconfig" = "$env:USERPROFILE";
    "git" = "$env:USERPROFILE";
    "mpv" = "$env:USERPROFILE\scoop\apps\mpv\current\portable_config";
    "vscode" = "$env:APPDATA\Code\User";
    "windows_terminal" = "C:\Users\blacklacost\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
  }

  Configure() {
    $this._cfgDir = "$($env:USERPROFILE)\.dotfiles";

    $this.InstallWindowsApps();
    $this.InstallPowershellModule("posh-git");
    # For fzf
    $this.InstallPowershellModule("PSEverything");
    $this.InstallPowershellModule("PSFzf");
    $this.HardLinkAppsConfigs();
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
      New-Item -ItemType HardLink ` -Path $psDir -Name "profile.ps1" -Target $psProfileCfg -Force
    }
  }

  hidden HardLinkModules() {
    $fullNameAndNameModules = Get-ChildItem .\modules\ | Select-Object FullName, Name, BaseName

    $fullNameAndNameModules | ForEach-Object {
      # Сделать foreach по PSModulePath
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
    Install-ScoopApp "fzf";
    Install-ScoopApp "googlechrome";
    Install-ScoopApp "git";
    Install-ScoopApp "miniconda3";
    Install-ScoopApp "Monoid-NF";
    Install-ScoopApp "mpv";
    Install-ScoopApp "rufus";
    Install-ScoopApp "telegram";
    Install-ScoopApp "vscode";
    Install-ScoopApp "whatsapp";
    Install-ScoopApp "qbittorrent";
  }

  hidden HardLinkAppsConfigs() {
    ForEach ($key in $this._windowsDirConfigs.keys) {
      $this.HardLinkAppConfigs($key, $this._windowsDirConfigs[$key]);
    }
  }

  hidden HardLinkAppConfigs($AppName, $dstDir) {
    $srcDir = Join-Path $this._cfgDir "config" $AppName;
    Get-ChildItem $srcDir | ForEach-Object {
      $srcPath = Join-Path $srcDir $_.Name;
      New-Item -ItemType HardLink -Path $dstDir -Name $_.Name -Target $srcPath -Force;
    }
  }

  hidden InstallPowershellModule($moduleName) {
    if (Get-InstalledModule | Where-Object Name -eq $moduleName) { return; }
    Install-Module $moduleName -Scope CurrentUser;
    if (-not $?) { throw "Failed" }
  }

}

$app = [App]::new();
$app.Configure();
