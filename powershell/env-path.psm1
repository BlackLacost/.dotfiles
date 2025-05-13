function Add-EnvPath {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory = $true)]
    [String] $Path,

    [ValidateSet('Machine', 'User', 'Process')]
    [String] $Target = 'Machine'
  )

  if (-not (Test-Path -Path $Path)) {
    Write-Error "Путь '$Path' не существует."
    return
  }

  $currentPath = [Environment]::GetEnvironmentVariable("PATH", $Target)
  if ($currentPath -split ';' -icontains $Path) {
    Write-Verbose "Путь '$Path' уже есть в PATH ($Target)"
    return
  }

  if ($PSCmdlet.ShouldProcess("Добавить путь '$Path' в PATH ($Target)")) {
    $newPath = "$currentPath;$Path"
    [Environment]::SetEnvironmentVariable("PATH", $newPath, $Target)
    Write-Output "Путь '$Path' успешно добавлен в PATH ($Target)"
  }
}

Export-ModuleMember -Function Add-EnvPath;