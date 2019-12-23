function LinkModules() {
  $modulesDir = "$env:USERPROFILE\.dotfiles\modules\";
  $fullNameAndNameModules = Get-ChildItem $modulesDir | Select-Object FullName, Name, BaseName;

  $fullNameAndNameModules | ForEach-Object {
    # Сделать foreach по PSModulePath
    $profileDir = Split-Path -parent $profile;
    $moduleDir = Join-Path $profileDir "Modules" $_.BaseName;
    New-Item $moduleDir -ItemType Directory -Force;
    New-Item -ItemType SymbolicLink -Path (Join-Path $moduleDir $_.Name) -Target $_.FullName -Force;
  }
}

git clone "https://github.com/BlackLacost/.dotfiles.git" "$env:USERPROFILE\.dotfiles";
LinkModules;
