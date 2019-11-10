function Get-DriveFree {
  $hardDisks = Get-PSDrive | Where-Object {$_.Free -gt 1}

  $hardDisks | ForEach-Object {
    $Count = 0; Write-Host "";
  } {
    Write-Host "Free Space for" $_.Root "is" ("{0:N2}" -f($_.Free/1gb)) "GB";
    $Count = $Count + $_.Free;
  } {
    Write-Host "";
    Write-Host "Total Free Space "("{0:N2}" -f ($Count/1gb)) "GB";
  }
}

Export-ModuleMember -function Get-DriveFree
