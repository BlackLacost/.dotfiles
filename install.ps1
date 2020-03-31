function LinkModules {
  $srcModulesDir = "$env:USERPROFILE\.dotfiles\modules\";
  Get-ChildItem $srcModulesDir | Select-Object FullName, Name, BaseName | ForEach-Object {
    # Сделать foreach по PSModulePath
    $powershellDir = Split-Path -parent $profile;
    $powershellModuleDir = Join-Path $powershellDir "Modules" $_.BaseName;
    New-Item $powershellModuleDir -ItemType Directory -Force;
    New-Item -ItemType SymbolicLink -Path (Join-Path $powershellModuleDir $_.Name) -Target $_.FullName -Force;
  }
}

git clone "https://github.com/BlackLacost/.dotfiles.git" "$env:USERPROFILE\.dotfiles";
LinkModules;

$currentPsDir = Split-Path -parent $profile;
$parentPsDir = Split-Path -Parent $currentPsDir;
$psDir = Join-Path $parentPsDir "PowerShell";
$dotfilesDir = "$env:USERPROFILE\.dotfiles\";
$psProfileCfg = Join-Path $dotfilesDir "profile.ps1";
if (-not (Test-Path -Path "$psDir\profile.ps1")) {
  New-Item -ItemType SymbolicLink -Path $psDir -Name "profile.ps1" -Target $psProfileCfg -Force
}
