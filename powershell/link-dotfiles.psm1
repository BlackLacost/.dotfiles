Import-Module .\powershell\join-paths;

$dotfilesDir = Join-Path -Path $HOME -ChildPath ".dotfiles";

function New-Link {
  param (
    [String]$Path,
    [String]$Name,
    [String]$Value,
    [ValidateSet('SymbolicLink', 'HardLink')][String]$ItemType
  )

  if ([String]::IsNullOrEmpty($Path)) {
    Write-Host "Path can't be empty when create New-Link" -ForegroundColor Red;
    exit;
  }

  if (-not (Test-Path -Path "$Path")) {
    Write-Host "Create new dir $Path for New-Link";
    New-Item -ItemType Directory -Path "$Path" -Force;
  }

  $isNameDir = $name.EndsWith("/");
  $withDir = "";
  $newName = $Name;

  if ($isNameDir) {
    $dstPath = Join-Path -Path $Path -ChildPath $Name;
    $withDir = " dir";
    $newName = $Name.Substring(0, $str.Length - 1);
    if (Test-Path -Path "$dstPath") {
      Remove-Item "$dstPath" -Recurse -Force;
    }
  }

  if ($ItemType -eq 'SymbolicLink') {
    Write-Host ("Creating softlink$withDir $Value => $Path\$newName");
    New-Item -ItemType SymbolicLink -Force -Path $Path -Name $newName -Target $Value;
  }
  if ($ItemType -eq 'HardLink') {
    Write-Host ("Creating hardlink$withDir $Value => $Path\$newName");
    New-Item -ItemType HardLink -Force -Path $Path -Name $newName -Value $Value;
  }
}

function New-LinkDotfiles {
  [CmdletBinding()]
  param (
    [ValidateSet(
      'code',
      'continue',
      'gitconfig',
      'mpv',
      'lsd',
      'powershell'
    )]
    $Name
  )

  switch ($Name) {
    'code' {
      $dstDir = Join-Paths -PathList @($env:APPDATA, "Code", "User");
      $srcDir = Join-Paths -PathList @($HOME, ".dotfiles", "config", "vscode");
      Write-Verbose "srcDir=$srcDir, dstDir=$dstDir"
      foreach ($filename in @("settings.json", "keybindings.json", "tasks.json", "snippets")) {
        $srcPath = Join-Path -Path $srcDir -ChildPath $filename;
        Write-Verbose "srcPath=$srcPath, dstDir=$dstDir, name=$filename"
        # SymbolicLink because dir;
        New-Link -ItemType SymbolicLink -Path $dstDir -Name $filename -Value $srcPath;
      }
    }
    'continue' {
      $dstDir = Join-Path -Path $HOME -ChildPath ".continue";
      $srcPath = Join-Paths -PathList @($HOME, ".dotfiles", "config", "vscode", "continue", "config.json");
      New-Link -ItemType SymbolicLink -Path $dstDir -Name "config.json" -Value $srcPath;
    }
    'gitconfig' {
      New-Link -ItemType HardLink -Path $HOME -Name ".gitconfig" -Value $(Join-Paths -PathList @($dotfilesDir, "config", "git", ".gitconfig"));
    }
    'mpv' {
      $dstDir = Join-Path -Path $env:APPDATA -ChildPath "mpv.net";
      $srcPath = Join-Paths -PathList @($dotfilesDir, "config", "mpv", "input.conf");
      New-Link -ItemType HardLink -Path $dstDir -Name "input.conf" -Value $srcPath
    }
    'lsd' {
      $dstDir = Join-Path -Path $env:APPDATA -ChildPath "lsd";
      $srcPath = Join-Paths -PathList @($dotfilesDir, "config", "lsd", "config.yaml");
      New-Link -ItemType HardLink -Path $dstDir -Name "config.yaml" -Value $srcPath
    }
    'powershell' {
      $powershellDir = Join-Paths -PathList @($HOME, "Documents", "PowerShell");
      $src = Join-Path -Path $dotfilesDir -ChildPath "profile.ps1";
      # Hardlink is overwritten by powershell
      New-Link -ItemType SymbolicLink -Path $powershellDir -Name "profile.ps1" -Value $src;
    }
    Default {}
  }
}

Export-ModuleMember -Function New-LinkDotfiles;
