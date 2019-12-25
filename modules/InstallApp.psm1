Import-Module -Name New-InstallScoopApp


class InstallApp {
  $scoop = (New-InstallScoopApp);

  $dotfilesDir = "$env:USERPROFILE\.dotfiles";

  [hashtable] $apps = [ordered] @{
    "posh-git" = @{
      "name" = "posh-git";
      "installType" = "powershellModule";
    };
    "anki" = @{
      "name" = "anki";
      "installType" = "scoop";
      "configDir" = "$env:USERPROFILE\scoop\apps\anki\current\data";
    };
    "git" = @{
      "name" = "git";
      "installType" = "scoop";
      "configDir" = "$env:USERPROFILE";
    };
    "vscode" = @{
      "name" = "vscode";
      "installType" = "scoop";
      "configDir" = "$env:APPDATA\Code\User";
      "vscodeExts" = @(
        "vscodevim.vim",
        "EditorConfig.EditorConfig",
        "vscode-icons-team.vscode-icons",
        "grigoryvp.language-xi",
        "grigoryvp.memory-theme"
      );
    };
    "mpv" = @{
      "name" = "mpv";
      "installType" = "scoop";
      "configDir" = "$env:USERPROFILE\scoop\apps\mpv\current\portable_config";
    };
    "dotfiles" = @{
      "name" = "dotfiles";
      "installType" = "git";
      "uri" = "https://github.com/BlackLacost/.dotfiles.git";
      "dstDir" = "$env:USERPROFILE\.dotfiles";
    };
    "xi" = @{
      "name" = "xi";
      "installType" = "git";
      "uri" = "https://gitlab.com/blacklacost/xi.git";
      "dstDir" = "$env:USERPROFILE\.xi";
    };
    "editorconfig" = @{
      "name" = "editorconfig";
      "installType" = "config";
      "configDir" = "$env:USERPROFILE";
    };
    "windows_terminal" = @{
      "name" = "windows_terminal";
      "installType" = "config";
      "configDir" = "$env:APPDATA\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState";
    };
  }
  InstallAll() {
    ForEach ($app in $this.apps.Values) {
      $this.Install($app);
    }
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
          $this.SymlinkAllInDir($srcDir, $app["configDir"]);
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
        if (Test-Path -Path $app["dstDir"]) { return; }
        git clone $app["uri"] $app["dstDir"];
      }

      "config" {
        $srcDir = Join-Path $this.dotfilesDir "config" $app["name"];
        $this.SymlinkAllInDir($srcDir, $app["configDir"]);
      }

      Default {Write-Host "Неподдерживаемый тип установки"}
    }
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
