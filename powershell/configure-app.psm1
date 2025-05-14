function Set-PowerOptions() {
  Write-Host "Setting power policy";
  powercfg -change -monitor-timeout-ac 120;
  powercfg -change -monitor-timeout-dc 120;
  powercfg -change -disk-timeout-ac 0;
  powercfg -change -disk-timeout-dc 0;
  powercfg -change -standby-timeout-ac 0;
  powercfg -change -standby-timeout-dc 0;
  powercfg -change -hibernate-timeout-ac 0;
  powercfg -change -hibernate-timeout-dc 0;
  # Disable hibernate & delete hiberfil.sys
  powercfg -hibernate off
  #  Set 'plugged in' cooling policy to 'active'
  # powercfg -setacvalueindex scheme_current 54533251-82be-4824-96c1-47b60b740d00 94d3a615-a899-4ac5-ae2b-e4d8f634367f 1
  #  Set 'on battery' cooling policy to 'active'
  #! If set to 'passive' will downclock cpu to minimum, unusable
  # powercfg -setdcvalueindex scheme_current 54533251-82be-4824-96c1-47b60b740d00 94d3a615-a899-4ac5-ae2b-e4d8f634367f 1
}

# TODO: Установка в папку пользователя
function Update-AuthGitHubCli {
  [CmdletBinding()]
  param ()

  if (-not (Test-GitHubCliAuth)) {
    Write-Host "Auth to GitHub";
    &gh auth login;
  }
  else {
    Write-Host "Already authenticated"
  }
}

function Update-ConfigurationVscode() {
  [CmdletBinding()]
  param()

  New-LinkDotfiles code;

  Install-CodeExtension continue;
  Install-CodeExtension memory-theme;
  # Install-VscodeExt grigoryvp.language-xi";
  # Install-VscodeExt grigoryvp.goto-link-provider";
  # Install-VscodeExt grigoryvp.markdown-python-repl-syntax";
  # Install-VscodeExt grigoryvp.markdown-pandoc-rawattr";
  # Install-VscodeExt EditorConfig.EditorConfig";
  Install-CodeExtension vscodevim;
  Install-CodeExtension markdown-inline-fence;
  Install-CodeExtension material-icon-theme;

  Install-CodeExtension angular-console;
  Install-CodeExtension prettier-vscode
  Install-CodeExtension prettier-eslint;
  Install-CodeExtension css-modules;
  Install-CodeExtension css-modules-highlights;
  Install-CodeExtension tailwindcss;
  Install-CodeExtension pretty-ts-errors;
  Install-CodeExtension thunder-client;
  Install-CodeExtension auto-close-tag;
  Install-CodeExtension powershell;
  Install-CodeExtension project-manager;
  Install-CodeExtension todo-tree;
  Install-CodeExtension event-better-toml;
  Install-CodeExtension yaml;
  # # Wrap all comments by Alt+Q or Ctrl+Q
  # $this._installVscodeExt("dnut.rewrap-revived");
  # $this._installVscodeExt("streetsidesoftware.code-spell-checker");
  # $this._installVscodeExt("streetsidesoftware.code-spell-checker-russian");
  # # $this._installVscodeExt("mark-wiemer.vscode-autohotkey-plus-plus");

  #     $docCfgDir = $this._path(@("~", "Documents", ".vscode"));
  #     if (-not (Test-Path -Path "$docCfgDir")) {
  #       New-Dir -Path "$docCfgDir";
  #     }

  #     $content = @'
  #       {
  #         "files.exclude": {
  #           "My Music/": true,
  #           "My Pictures/": true,
  #           "My Videos/": true,
  #           "My Games/": true,
  #           "Sound Recordings/": true,
  #           "Diablo IV/": true,
  #           "PowerShell": true,
  #           "WindowsPowerShell": true,
  #           "desktop.ini": true,
  #           ".vscode/": true
  #         }
  #       }
  # '@;

  #     New-File -Path $docCfgDir -Name "settings.json" -Value "$content";

  ##  Exclude from 'ls'.
  # $(Get-Item -Force $docCfgDir).Attributes = 'Hidden';
}

function Update-AppConfig {
  [CmdletBinding()]
  param (
    [ValidateSet(
      'code',
      'gh',
      'nvm',
      'ollama',
      'power',
      'powershell',
      'taskbar'
    )]
    [String] $Name
  )

  switch ($Name) {
    'code' {
      Update-ConfigurationVscode;
    }
    'gh' {
      Update-AuthGitHubCli;
    }
    'nvm' {
      & nvm install lts;
      Write-Host "nvm install last lts version";
      & nvm use lts;
      Write-Host "Updating npm"
      & npm install -g npm@latest
    }
    'ollama' {
      $ollamaDir = "D:\.ollama";
      Write-Host $ollamaDir;
      if (-not (Test-Path -Path $ollamaDir)) {
        Write-Host "Create ollama dir $ollamaDir";
        New-Dir -Path $ollamaDir;
      }
      $newOllamaDir = Join-Path -Path $HOME -ChildPath .ollama;
      if (Test-Path -Path $newOllamaDir) {
        Write-Host "Remove ollama dir $newOllamaDir";
        Remove-Item $newOllamaDir -Force -Recurse;
      }
      New-SoftlinkDir -Path $newOllamaDir -Target $ollamaDir;
    }
    'power' {
      Set-PowerOptions;
    }
    'powershell' {
      # Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted;
      # Install-PowershellModule -ModuleName "WindowsCompatibility";
      # Symlink PowerShel config file into PowerShell config dir.
      New-LinkDotfiles powershell;
    }
    'taskbar' {
      # Hide search in the taskbar
      $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
      # 0 hide; 1 search; 2 search input
      Set-ItemProperty -Path $path -Name SearchboxTaskbarMode -Value 0;
    }
    Default {}
  }
}

function Uninstall-App {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [String] $Name
  )

  if (-not (Test-AppInstalled -Name $Name)) {
    Write-Verbose "$Name is already uninstalled"
    return
  }

  Write-Host "Uninstalling $Name..."
  & winget uninstall --silent $Name
  if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to uninstall $Name"
    return
  }
}


Export-ModuleMember -Function Update-AppConfig;
