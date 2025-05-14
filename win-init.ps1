$isAdmin = [bool]([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($isAdmin) {
  Write-Host "Скрипт запущен от имени администратора."
  winget install --silent --accept-package-agreements --accept-source-agreements github.cli git.git microsoft.powershell
  Set-ExecutionPolicy Unrestricted -Scope CurrentUser
}
else {
  Write-Error "Запустите скрипт под администратором"
}
