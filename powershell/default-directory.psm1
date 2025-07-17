$registerUserFolders = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders";

function Get-DefaultFolderPath {
  [CmdletBinding()]
  param (
    [ValidateSet('MyDocuments', 'MyVideos', 'Downloads')]
    [String] $Directory
  )

  # TODO: Get this guid dynamic
  if ($Directory -eq "Downloads") {
    $downloadsGuid = Get-DefaultFolderRegisterName -Directory Downloads;
    $currentDownloadsPath = (Get-ItemProperty -Path $registerUserFolders -Name $downloadsGuid).$downloadsGuid;
    return $currentDownloadsPath;
  }

  return [Environment]::GetFolderPath([Environment+SpecialFolder]::$Directory)
}

function Get-DefaultFolderRegisterName {
  [CmdletBinding()]
  param (
    [ValidateSet('MyDocuments', 'MyVideos', 'Downloads')]
    [String] $Directory
  )

  if ($Directory -eq "MyDocuments") {
    return "Personal"
  }

  if ($Directory -eq "MyVideos") {
    return "My Video"
  }

  # TODO: Get this guid dynamic
  if ($Directory -eq "Downloads") {
    return "{374DE290-123F-4565-9164-39C4925E467B}";
  }

  return ""
}
function Move-WindowDefaultDirectories {
  [CmdletBinding()]
  param ()

  Move-WindowDefaultDirectory -Directory MyDocuments -Path "$HOME\Documents";
  Move-WindowDefaultDirectory -Directory MyVideos -Path "D:\Videos";
  Move-WindowDefaultDirectory -Directory Downloads -Path "D:\Downloads";

  # Restart explorer
  Stop-Process -ProcessName explorer -Force
}

function Move-WindowDefaultDirectory {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [String] $Path,

    [ValidateSet('MyDocuments', 'MyVideos', 'Downloads')]
    [String] $Directory
  )

  $NewPath = $Path;
  $OldPath = Get-DefaultFolderPath -Directory $Directory;
  $RegisterName = Get-DefaultFolderRegisterName -Directory $Directory;

  if ($OldPath -eq $NewPath) {
    Write-Verbose "Directory $newPath already moved"
    return;
  }

  # Проверка существования исходной папки
  if (-Not (Test-Path -Path $OldPath)) {
    Write-Host "Create dir OldPath=$OldPath NewPath=$NewPath RegisterName=$RegisterName"
    New-Item -ItemType Directory -Force -Path $OldPath;
    # Write-Host "Ошибка: Папка $oldPath не найдена!" -ForegroundColor Red
    # Read-Host "Нажмите Enter для выхода"
    # exit
  }

  # Создание новой папки на D:
  if (-Not (Test-Path -Path $NewPath)) {
    Write-Host "Create dir $NewPath";
    New-Item -ItemType Directory -Path $NewPath;
  }

  # Перемещение файлов (робастное копирование с удалением оригинала)
  Write-Host "Move from $OldPath to $NewPath";
  robocopy "$OldPath" "$NewPath" /E /COPYALL /MOVE /R:3 /W:5

  # Обновление пути в реестре
  Write-Host "Set $($registerUserFolders)\$RegisterName to $NewPath";
  Set-ItemProperty -Path $registerUserFolders -Name $RegisterName -Value $NewPath

  # Обновление пути в системе
  $shell = New-Object -ComObject Shell.Application
  $folder = $shell.Namespace($NewPath)
  $folder.Self.InvokeVerb("properties") # Принудительное обновление

  Write-Host "Папка $OldPath успешно перенесена в:" -ForegroundColor Green
  Write-Host "Новый путь: $NewPath" -ForegroundColor Yellow
}

Export-ModuleMember -Function Move-WindowDefaultDirectories, Get-DefaultFolderPath;