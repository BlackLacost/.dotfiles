Import-Module -Name New-InstallScoopApp

class Dotfiles {

  $dotfilesDir = "$env:USERPROFILE\.dotfiles";
  $_windowsDirConfigs = @{
    "anki" = "$env:USERPROFILE\scoop\apps\anki\current\data"
    "editorconfig" = "$env:USERPROFILE";
    "git" = "$env:USERPROFILE";
    "mpv" = "$env:USERPROFILE\scoop\apps\mpv\current\portable_config";
    "vscode" = "$env:APPDATA\Code\User";
    "windows_terminal" = "$env:APPDATA\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
  }
  $_scoop = (New-InstallScoopApp);
  hidden $myVscodeExts = @(
    "vscodevim.vim",
    "EditorConfig.EditorConfig",
    "vscode-icons-team.vscode-icons",
    "grigoryvp.language-xi",
    "grigoryvp.memory-theme"
  );
  hidden $gitRepositories = @{
    "https://github.com/BlackLacost/.dotfiles.git" = $this.dotfilesDir;
    "https://gitlab.com/blacklacost/xi.git" = "$env:USERPROFILE\.xi"
  }
  hidden $testApps = @("git", "anki", "Monoid-NF", "vscode");
  hidden $basicApps = @(
    "git", "sudo", "anki", "googlechrome", "Monoid-NF", "mpv", "potplayer", "telegram", "vscode", "whatsapp", "qbittorrent"
  );
  hidden $extraApps = @(
    "colortool", "nvm", "rufus", "fzf", "foxit-reader"
  );
  hidden $fullApps = $this.basicApps + $this.extraApps;

  Configure() {
    Write-Host $this.dotfilesDir;
    $this.InstallWindowsApps();
    ForEach ($uri in $this.gitRepositories.keys) {
      $dstDir = $this.gitRepositories[$uri];
      $this.GitClone($uri, $dstDir);
    }
    $this.InstallPowershellModule("posh-git");
    # For fzf
    $this.InstallPowershellModule("PSEverything");
    $this.InstallPowershellModule("PSFzf");
    $this.LinkAppsConfigs();
    $this.ConfigureVscode();
    $this.LinkModules();
    $this.SetPowerOptions();

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
    $psProfileCfg = "$($this.dotfilesDir)/profile.ps1";
    if (-not (Test-Path -Path "$psDir/profile.ps1")) {
      New-Item -ItemType SymbolicLink ` -Path $psDir -Name "profile.ps1" -Target $psProfileCfg -Force
    }
  }

  LinkModules() {
    $srcModulesDir = "$($this.dotfilesDir)\modules\";
    Get-ChildItem $srcModulesDir | Select-Object FullName, Name, BaseName | ForEach-Object {
      # Сделать foreach по PSModulePath
      $powershellDir = Split-Path -parent $profile;
      $powershellModuleDir = Join-Path $powershellDir "Modules" $_.BaseName;
      New-Item $powershellModuleDir -ItemType Directory -Force;
      New-Item -ItemType SymbolicLink -Path (Join-Path $powershellModuleDir $_.Name) -Target $_.FullName -Force;
    }
  }

  hidden InstallWindowsApps() {
    ForEach ($app in $this.fullApps) {
      $this._scoop.InstallScoopApp($app);
    }
  }

  hidden GitClone($uri, $dstDir) {
    if (Test-Path -Path $dstDir) { return; }
    git clone $uri $dstDir;
  }

  hidden LinkAppsConfigs() {
    ForEach ($appName in $this._windowsDirConfigs.keys) {
      $srcDir = Join-Path $this.dotfilesDir "config" $appName;
      $this.SymlinkAllInDir($srcDir, $this._windowsDirConfigs[$appName]);
    }
  }

  hidden ConfigureVscode() {
    $extList = @(& code --list-extensions);
    ForEach ($ext in $this.myVscodeExts) {
      if (-not $extList.Contains($ext)) {
        & code --install-extension $ext;
        if ($LASTEXITCODE -ne 0) { throw "Failed" }
      }
    }
  }

  [bool] hidden TestPathIsDir($path) {
    return (Get-Item $path) -is [System.IO.DirectoryInfo];
  }

  hidden SymlinkAllInDir($srcDir, $dstDir) {
    Get-ChildItem $srcDir | ForEach-Object {
      $srcPath = Join-Path $srcDir $_.Name;
      New-Item -ItemType SymbolicLink -Path $dstDir -Name $_.Name -Target $srcPath -Force;
    }
  }

  hidden InstallPowershellModule($moduleName) {
    if (Get-InstalledModule | Where-Object Name -eq $moduleName) { return; }
    Install-Module $moduleName -Scope CurrentUser;
    if (-not $?) { throw "Failed" }
  }

  hidden SetPowerOptions() {
    powercfg -change -monitor-timeout-ac 120;
    powercfg -change -monitor-timeout-dc 120;
    powercfg -change -disk-timeout-ac 0;
    powercfg -change -disk-timeout-dc 0;
    powercfg -change -standby-timeout-ac 0;
    powercfg -change -standby-timeout-dc 0;
    powercfg -hibernate off;
  }

}

function New-Dotfiles() {
  return [Dotfiles]::new();
}

Export-ModuleMember -Function New-Dotfiles
