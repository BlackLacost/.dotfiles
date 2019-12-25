LinkModules {
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
