class App {

  $_cfgDir = $null;

  configure() {
    $this._cfgDir = "$($env:USERPROFILE)\.dotfiles";

    $this._installPowershellModule("posh-git");
    $this._configureVscode();

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
        -Target $psProfileCfg
    }
  }

  _configureVscode() {
    $dstDir = "$($env:APPDATA)\Code\User";

    # Создавать директорию, только если ее ещё не было
    if (-not (Test-Path -Path $dstDir)) {
      New-Item -Path $dstDir -ItemType Directory | Out-Null;
    }

    $srcPath = "$($this._cfgDir)\vscode_settings.json";
    $dstPath = "$dstDir\settings.json";
    New-Item -ItemType SymbolicLink -Path $dstPath -Target $srcPath -Force;

    $srcPath = "$($this._cfgDir)\vscode_keybindings.json";
    $dstPath = "$dstDir\keybindings.json";
    New-Item -ItemType SymbolicLink -Path $dstPath -Target $srcPath -Force;
  }

  _installPowershellModule($moduleName) {
    if (Get-InstalledModule | Where-Object Name -eq $moduleName) { return; }
    Install-Module $moduleName -Scope CurrentUser;
    if (-not $?) { throw "Failed" }
  }

}

$app = [App]::new();
$app.configure();
