Import-Module -Name New-InstallScoopApp

class Dotfiles {

  $dotfilesDir = "$env:USERPROFILE\.dotfiles";
  $windowsConfigDir = @{
    "anki" = "$env:USERPROFILE\scoop\apps\anki\current\data";
    "editorconfig" = "$env:USERPROFILE";
    "git" = "$env:USERPROFILE";
    "mpv" = "$env:USERPROFILE\scoop\apps\mpv\current\portable_config";
    "vscode" = "$env:APPDATA\Code\User";
    "windows_terminal" = "$env:APPDATA\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
  }
  $scoop = (New-InstallScoopApp);
  $vscodeExts = @(
    "vscodevim.vim",
    "EditorConfig.EditorConfig",
    "vscode-icons-team.vscode-icons",
    "grigoryvp.language-xi",
    "grigoryvp.memory-theme"
  );
  $gitRepositories = @{
    ".dotfiles" = "https://github.com/BlackLacost/.dotfiles.git"
    ".xi" = "https://gitlab.com/blacklacost/xi.git"
  }

  $testApps = @("git", "anki", "Monoid-NF", "vscode");
  $basicApps = @(
    "git", "sudo", "anki", "googlechrome", "Monoid-NF", "mpv", "potplayer", "telegram", "vscode", "whatsapp", "qbittorrent"
  );
  $extraApps = @(
    "colortool", "nvm", "rufus", "foxit-reader"
  );
  $fullApps = $this.basicApps + $this.extraApps;


  [void] Configure() {
    $this.InstallWindowsApps($this.basicApps);
    $this.GitClones();
    $this.InstallPowershellModule("posh-git");
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

  hidden InstallWindowsApps($apps) {
    ForEach ($app in $apps) {
      $this.scoop.InstallScoopApp($app);
    }
  }

  hidden GitClone($uri, $dstDir) {
    if (Test-Path -Path $dstDir) { return; }
    git clone $uri $dstDir;
  }

  GitClones() {
    ForEach ($app in $this.gitRepositories.keys) {
      $uri = $this.gitRepositories[$app];
      $dstDir = Join-Path $env:USERPROFILE $app;
      $this.GitClone($uri, $dstDir);
    }
  }

  hidden LinkAppsConfigs() {
    ForEach ($appName in $this.windowsConfigDir.keys) {
      $srcDir = Join-Path $this.dotfilesDir "config" $appName;
      $this.SymlinkAllInDir($srcDir, $this.windowsConfigDir[$appName]);
    }
  }

  hidden ConfigureVscode() {
    $extList = @(& code --list-extensions);
    ForEach ($ext in $this.vscodeExts) {
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
