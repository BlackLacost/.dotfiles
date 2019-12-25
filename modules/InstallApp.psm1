Import-Module -Name New-InstallScoopApp


class InstallApp {
  $scoop = (New-InstallScoopApp);
  $dotfilesDir = "$env:USERPROFILE\.dotfiles";

  InstallAll() {
    [hashtable] $appsConfig = $this.LoadAppsConfigFromJson();

    if (-not $this.scoop.HasApp("sudo")) {
      $this.scoop.InstallScoopApp("sudo");
    }

    ForEach ($appConfig in $appsConfig.Values) {
      $this.Install($appConfig);
    }
  }

  [hashtable] LoadAppsConfigFromJson() {
    $jsonFile = "$($this.dotfilesDir)\apps.json";
    return Get-Content -Path $jsonFile | ConvertFrom-Json -AsHashtable;
  }

  Install([hashtable] $app) {
    switch ($app["installType"]) {
      "powershellModule" {
        if (Get-InstalledModule | Where-Object Name -eq $app["name"]) { return; }
        Install-Module $app["name"] -Scope CurrentUser;
        if (-not $?) { throw "Failed" }
      }

      "scoop" {
        $this.scoop.InstallScoopApp($app["name"]);

        if ($app.ContainsKey("configDir")) {
          $srcDir = Join-Path $this.dotfilesDir "config" $app["name"];
          $dstDir = $this.ExpandEnv($app["configDir"]);
          $this.SymlinkAllInDir($srcDir, $dstDir);
        }

        if ($app.ContainsKey("vscodeExts")) {
          $extList = @(& code --list-extensions);
          ForEach ($ext in $app["vscodeExts"]) {
            if (-not $extList.Contains($ext)) {
              & code --install-extension $ext;
              if ($LASTEXITCODE -ne 0) { throw "Failed" }
            }
          }
        }
      }

      "git" {
        $dstDir = $this.ExpandEnv($app["dstDir"]);
        if (Test-Path -Path $dstDir) { return; }
        git clone $app["uri"] $dstDir;
      }

      "config" {
        $srcDir = Join-Path $this.dotfilesDir "config" $app["name"];
        $dstDir = $this.ExpandEnv($app["configDir"]);
        $this.SymlinkAllInDir($srcDir, $dstDir);
      }

      Default {Write-Host "Неподдерживаемый тип установки"}
    }
  }

  [string] ExpandEnv($dstDir) {
    $dirArray = @($dstDir.Split('\'));
    # Преобразует string env, например %USERPROFILE%
    $dirArray[0] = [System.Environment]::ExpandEnvironmentVariables($dirArray[0])
    return $dirArray -join "\"
  }

  hidden SymlinkAllInDir($srcDir, $dstDir) {
    Get-ChildItem $srcDir | ForEach-Object {
      $srcPath = Join-Path $srcDir $_.Name;
      New-Item -ItemType SymbolicLink -Path $dstDir -Name $_.Name -Target $srcPath -Force;
    }
  }

}

function New-InstallApp() {
  return [InstallApp]::New();
}

Export-ModuleMember -Function New-InstallApp
