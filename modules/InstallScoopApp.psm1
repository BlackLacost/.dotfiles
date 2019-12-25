class Scoop {
  hidden $buckets = @{
    "Monoid-NF" = "nerd-fonts";
    "smplayer" = "jfut";
  }

  hidden $bucketsUri = @{
    "smplayer" = "https://github.com/jfut/scoop-jfut";
  }

  hidden $sudo = @("Monoid-NF");

  Scoop() {
    if (-not $this.CheckBucketAdded("extras")) {
      scoop bucket add extras;
    }
  }

  [bool] hidden IsAppStatusInstalled($appName) {
    $res = & scoop info $appName;
    if ($LASTEXITCODE -ne 0) { return $false; }
    return (-not ($res | Out-String).Contains("Installed: No"));
  }

  [bool] HasApp($appName) {
    if (-not ($this.IsAppStatusInstalled($appName))) { return $false; }
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

  [bool] CheckBucketAdded($bucketName) {
    return (scoop bucket list).Contains($bucketName);
  }

  InstallScoopApp($appName) {
    if ($this.HasApp($appName)) { return; }
    if ($this.IsAppStatusInstalled($appName)) {
      # if install fails, scoop will treat app as installed.
      # $this._prompt("'$appName' corrupted, press any key to reinstall");
      Write-Host ("Uninstall $appName");
      scoop uninstall $appName;
    }

    if ($this.buckets.ContainsKey($appName)) {
      $bucketName = $this.buckets[$appName];
      if (-not $this.CheckBucketAdded($bucketName)) {
        if ($this.bucketsUri.ContainsKey($appName)) {
          scoop bucket add $BucketName $this.bucketsUri[$appName];
        } else {
          scoop bucket add $BucketName;
        }
      }
    }

    if ($this.sudo -contains $appName) {
      # Start-Process scoop.cmd -Wait -Verb RunAs -ArgumentList "install $appName";
      sudo scoop install $appName;
    } else {
      scoop install $appName;
    }

    if ($LASTEXITCODE -ne 0) {
      Write-Host ("Failed during installation", $appName);
      throw "Failed";
    }
  }
}

function New-InstallScoopApp() {
  return [Scoop]::New();
}

Export-ModuleMember -Function New-InstallScoopApp
