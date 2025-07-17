function Add-EnvPath {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory = $true)]
    [String] $Path,

    [ValidateSet('Machine', 'User', 'Process')]
    [String] $Target = 'Machine'
  )

  if ($Target -eq 'Machine') {
    $isAdmin = [bool]([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
      throw "Admin required for add path $Path with target $Target"
    }
  }

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


function Add-MyEnvPath {
  [CmdletBinding()]
  param (
    [ValidateSet(
      'keepass'
    )]
    [String] $Path,

    [ValidateSet('Machine', 'User', 'Process')]
    [String] $Target = 'Machine'
  )

  switch ($Path) {
    'keepass' { Add-EnvPath -Path "C:\Program Files\KeePassXC" -Target $Target }
    Default {}
  }
}

Export-ModuleMember -Function Add-EnvPath, Add-MyEnvPath;
