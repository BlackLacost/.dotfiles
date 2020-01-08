Import-Module -Name New-InstallApp

class Dotfiles {

  $dotfilesDir = "$env:USERPROFILE\.dotfiles";
  $install = (New-InstallApp);
  $testApps = @("git", "anki", "Monoid-NF", "vscode");
  $basicApps = @(
    "git", "sudo", "anki", "googlechrome", "Monoid-NF", "mpv", "potplayer", "telegram", "vscode", "whatsapp", "qbittorrent"
  );
  $extraApps = @(
    "colortool", "nvm", "rufus", "foxit-reader"
  );
  $fullApps = $this.basicApps + $this.extraApps;

  [void] Configure() {
    $this.LinkModules();
    $this.install.InstallAll();
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
    $psProfileCfg = "$($this.dotfilesDir)\profile.ps1";
    if (-not (Test-Path -Path "$psDir\profile.ps1")) {
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

  # [bool] hidden TestPathIsDir($path) {
  #   return (Get-Item $path) -is [System.IO.DirectoryInfo];
  # }

  hidden SymlinkAllInDir($srcDir, $dstDir) {
    Get-ChildItem $srcDir | ForEach-Object {
      $srcPath = Join-Path $srcDir $_.Name;
      New-Item -ItemType SymbolicLink -Path $dstDir -Name $_.Name -Target $srcPath -Force;
    }
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
