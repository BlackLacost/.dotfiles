$isAdmin = [bool]([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($isAdmin) {
  winget install --silent --accept-package-agreements --accept-source-agreements github.cli git.git microsoft.powershell
  Set-ExecutionPolicy Unrestricted -Scope CurrentUser
}
else {
  Write-Error "Run this file as Admin"
}
