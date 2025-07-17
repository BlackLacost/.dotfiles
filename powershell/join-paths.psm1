function Join-Paths {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string[]] $PathList
  )

  $result = $PathList[0]
  for ($i = 1; $i -lt $PathList.Count; $i++) {
    $result = Join-Path -Path $result -ChildPath $PathList[$i];
  }

  return $result;
}

Export-ModuleMember -Function Join-Paths;