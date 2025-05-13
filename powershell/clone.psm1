Import-Module .\powershell\install-app;

function Clone-GitHub {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter()]
    [string] $Name,

    [Parameter()]
    [string] $DestinationDirectory,

    [switch]
    $Force
  )

  if (-not (Test-AppInstalled -Name Github.cli)) {
    Write-Warning("GitHub CLI not installed. Use Install-GitHubCli ndwto install it.");
    Install-App gh;
  }
  if (-not (Test-GitHubCliAuth)) {
    Write-Warning("GitHub CLI not auth. Use gh auth login to authenticate.");
  }

  # Выводим информацию о параметрах
  Write-Verbose "Repository name: $Name"
  Write-Verbose "Destination directory: $DestinationDirectory"

  # Проверяем, существует ли уже директория
  if (Test-Path -Path $DestinationDirectory) {
    if (-not $Force) {
      Write-Warning "Directory '$DestinationDirectory' already exists. Use -Force to skip check."
      return
    }
    else {
      Write-Verbose "Remove directory $DestinationDirectory, because exists."
      Remove-Item -Force -Recurse -Path $DestinationDirectory;
    }
  }

  # Поддержка ShouldProcess (-WhatIf / -Confirm)
  if ($PSCmdlet.ShouldProcess("Cloning dotfiles into $DestinationDirectory", "Git Clone")) {
    try {
      Write-Verbose "Running git clone command..."
      & gh repo clone $Name $DestinationDirectory

      # Проверяем код выхода
      if ($LASTEXITCODE -ne 0) {
        throw "Git clone failed with exit code $LASTEXITCODE"
      }

      Write-Output "Dotfiles successfully cloned to $DestinationDirectory"
    }
    catch {
      Write-Error "Failed to clone dotfiles: $_"
    }
  }
}

function Clone {
  [CmdletBinding()]
  param (
    [ValidateSet('dotfiles', 'pkm', 'obsidian-review-plugin')]
    $Name
  )

  switch ($Name) {
    'dofiles' {
      Clone-GitHub -Name ".dotfiles" -DestinationDirectory $(Join-Path -Path $HOME -ChildPath ".dotfiles");
    }
    'obsidian-review-plugin' {
      $dstDir = $(Join-Paths -PathList @($HOME, "pkm" , ".obsidian", "plugins", "obsidian-review-plugin"));
      Clone-GitHub -Name "obsidian-review-plugin" -DestinationDirectory $dstDir;
    }
    'pkm' {
      Clone-GitHub -Name "pkm" -DestinationDirectory $(Join-Path -Path $HOME -ChildPath "pkm");
    }
    Default {}
  }
}

Export-ModuleMember -Function Clone;
