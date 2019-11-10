$buckets = @{
  "anki" = "extras";
  "autohotkey" = "extras";
  "whatsapp" = "extras";
  "Monoid-NF" = "nerd-fonts";
  "smplayer" = "jfut";
}

$bucketsUri = @{
  "smplayer" = "https://github.com/jfut/scoop-jfut";
}

$sudo = @("Monoid-NF");

function IsAppStatusInstalled($appName) {
  $res = & scoop info $appName;
  if ($LASTEXITCODE -ne 0) { return $false; }
  return (-not ($res | Out-String).Contains("Installed: No"));
}

function HasApp($appName) {
  if (-not (IsAppStatusInstalled($appName))) { return $false; }
  $res = @(& scoop info $appName);
  $installMarkIdx = $res.IndexOf("Installed:");
  if ($installMarkIdx -eq -1) { return $false; }
  $installDir = $res[$installMarkIdx + 1];
  if (-not $installDir) { return $false; }
  $installDir = $installDir.Trim();
  # if install fails, scoop will treat app as installed, but install dir
  # is not created.
  if (-not (Test-Path -Path $installDir)) { return $false; }
  $content = Get-ChildItem $installDir;
  return ($content.Length -gt 0);
}

function Install-ScoopApp {
  param(
    [string]$AppName
  )

  if (HasApp($AppName)) { return; }
  if (IsAppStatusInstalled($AppName)) {
    # if install fails, scoop will treat app as installed.
    # $this._prompt("'$appName' corrupted, press any key to reinstall");
    Write-Host ("Uninstall $AppName");
    scoop uninstall $AppName;
  }

  if ($buckets.ContainsKey($AppName)) {
    $BucketName = $buckets[$AppName];
    $contained = $(scoop bucket list).Contains($BucketName);
    if (-not $contained) {
      if ($bucketsUri.ContainsKey($AppName)) {
        scoop bucket add $BucketName $bucketsUri[$AppName];
      } else {
        scoop bucket add $BucketName;
      }
    }
  }

  if ($sudo -contains $AppName) {
    # Start-Process scoop.cmd -Wait -Verb RunAs -ArgumentList "install $AppName";
    sudo scoop install $AppName;
  } else {
    scoop install $AppName;
  }

  if ($LASTEXITCODE -ne 0) {
    Write-Host ("Failed during installation", $AppName);
    throw "Failed";
  }
}

Export-ModuleMember -function Install-ScoopApp
