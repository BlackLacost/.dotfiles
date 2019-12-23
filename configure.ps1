# Import-Module -Name "$PSScriptRoot\modules\InstallScoopApp.psm1"

class Scoop {
  $_buckets = @{
    "anki" = "extras";
    "autohotkey" = "extras";
    "whatsapp" = "extras";
    "Monoid-NF" = "nerd-fonts";
    "smplayer" = "jfut";
  }

  $_bucketsUri = @{
    "smplayer" = "https://github.com/jfut/scoop-jfut";
  }

  $_sudo = @("Monoid-NF");

  [bool] hidden IsAppStatusInstalled($appName) {
    $res = & scoop info $appName;
    if ($LASTEXITCODE -ne 0) { return $false; }
    return (-not ($res | Out-String).Contains("Installed: No"));
  }

  [bool] hidden HasApp($appName) {
    if (-not ($this.IsAppStatusInstalled($appName))) { return $false; }
    $res = @(& scoop info $appName);
    $installMarkIdx = $res.IndexOf("Installed:");
    if ($installMarkIdx -eq -1) { return $false; }
    $installDir = $res[$installMarkIdx + 1];
    if (-not $installDir) { return $false; }
    $installDir = $installDir.Trim();
    # if install fails, scoop will treat app as installed, but install dir
    # is not created.
    if (-not (Test-Path -Path $installDir)) { return $false; }
    $content = Get-ChildItem $installDir;
    return ($content.Length -gt 0);
  }

  InstallScoopApp($appName) {
    if ($this.HasApp($appName)) { return; }
    if ($this.IsAppStatusInstalled($appName)) {
      # if install fails, scoop will treat app as installed.
      # $this._prompt("'$appName' corrupted, press any key to reinstall");
      Write-Host ("Uninstall $appName");
      scoop uninstall $appName;
    }

    if ($this._buckets.ContainsKey($appName)) {
      $BucketName = $this._buckets[$appName];
      $contained = $(scoop bucket list).Contains($BucketName);
      if (-not $contained) {
        if ($this._bucketsUri.ContainsKey($appName)) {
          scoop bucket add $BucketName $this._bucketsUri[$appName];
        } else {
          scoop bucket add $BucketName;
        }
      }
    }

    if ($this._sudo -contains $appName) {
      # Start-Process scoop.cmd -Wait -Verb RunAs -ArgumentList "install $appName";
      sudo scoop install $appName;
    } else {
      scoop install $AppName;
    }

    if ($LASTEXITCODE -ne 0) {
      Write-Host ("Failed during installation", $appName);
      throw "Failed";
    }
  }
}


class App {

  $_cfgDir = "$env:USERPROFILE\.dotfiles";
  $_windowsDirConfigs = @{
    "anki" = "$env:USERPROFILE\scoop\apps\anki\current\data"
    "editorconfig" = "$env:USERPROFILE";
    "git" = "$env:USERPROFILE";
    "mpv" = "$env:USERPROFILE\scoop\apps\mpv\current\portable_config";
    "vscode" = "$env:APPDATA\Code\User";
    "windows_terminal" = "$env:APPDATA\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
  }
  $_scoop = [Scoop]::new();
  hidden $myVscodeExts = @(
    "vscodevim.vim",
    "EditorConfig.EditorConfig",
    "vscode-icons-team.vscode-icons",
    "grigoryvp.language-xi",
    "grigoryvp.memory-theme"
  );
  hidden $gitRepositories = @{
    "https://github.com/BlackLacost/.dotfiles.git" = $this._cfgDir;
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
    $this.HardLinkModules();
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
    $psProfileCfg = "$($this._cfgDir)/profile.ps1";
    if (-not (Test-Path -Path "$psDir/profile.ps1")) {
      New-Item -ItemType SymbolicLink ` -Path $psDir -Name "profile.ps1" -Target $psProfileCfg -Force
    }
  }

  hidden HardLinkModules() {
    $modulesDir = "$($this._cfgDir)\modules\"
    $fullNameAndNameModules = Get-ChildItem $modulesDir | Select-Object FullName, Name, BaseName

    $fullNameAndNameModules | ForEach-Object {
      # Сделать foreach по PSModulePath
      $profileDir = Split-Path -parent $profile;
      $moduleDir = Join-Path $profileDir "Modules" $_.BaseName;
      New-Item $moduleDir -ItemType Directory -Force;
      New-Item -ItemType HardLink -Path (Join-Path $moduleDir $_.Name) -Target $_.FullName -Force;
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
      $srcDir = Join-Path $this._cfgDir "config" $appName;
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

$app = [App]::new();
$app.Configure();
