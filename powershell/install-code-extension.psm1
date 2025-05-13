# TODO: Export only Install-CodeExtension
function Install-VscodeExt {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [String] $ExtId
  )

  $extList = @(& code --list-extensions);
  if (-not $extList.Contains($ExtId)) {
    & code --install-extension "$ExtId";
    if ($LASTEXITCODE -ne 0) { throw "Failed to install $ExtId" }
  }
}

function Install-CodeExtension {
  [CmdletBinding()]
  param (
    [ValidateSet(
      "angular-console",
      "auto-close-tag",
      "continue",
      "css-modules",
      "css-modules-highlights",
      "event-better-toml",
      "markdown-inline-fence",
      "material-icon-theme",
      "memory-theme",
      "powershell",
      "prettier-vscode",
      "prettier-eslint",
      "pretty-ts-errors",
      "project-manager",
      "tailwindcss",
      "todo-tree",
      "thunder-client",
      "vscodevim",
      "yaml"
    )]
    $Name)

  switch ($Name) {
    "angular-console" {
      Install-VscodeExt "nrwl.angular-console";
    }
    "auto-close-tag" {
      Install-VscodeExt "formulahendry.auto-close-tag";
    }
    "continue" {
      Install-VscodeExt "continue.continue";
      New-LinkDotfiles continue;
    }
    "css-modules" {
      Install-VscodeExt "clinyong.vscode-css-modules";
    }
    "css-modules-highlights" {
      Install-VscodeExt "andrewleedham.vscode-css-modules";
    }
    "event-better-toml" {
      Install-VscodeExt "tamasfe.even-better-toml";
    }
    "markdown-inline-fence" {
      Install-VscodeExt "grigoryvp.markdown-inline-fence";
    }
    "material-icon-theme" {
      Install-VscodeExt "pkief.material-icon-theme";
    }
    "memory-theme" {
      Install-VscodeExt "grigoryvp.memory-theme";
    }
    "powershell" {
      Install-VscodeExt "ms-vscode.powershell";
    }
    "prettier" {
      Install-VscodeExt "esbenp.prettier-vscode";
    }
    "prettier-eslint" {
      Install-VscodeExt "rvest.vs-code-prettier-eslint";
    }
    "pretty-ts-errors" {
      Install-VscodeExt "yoavbls.pretty-ts-errors";
    }
    "project-manager" {
      Install-VscodeExt "alefragnani.project-manager";
    }
    "tailwindcss" {
      Install-VscodeExt "bradlc.vscode-tailwindcss";
    }
    "todo-tree" {
      Install-VscodeExt "gruntfuggly.todo-tree";
    }
    "thunder-client" {
      Install-VscodeExt "rangav.vscode-thunder-client";
    }
    "vscodevim" {
      Install-VscodeExt "vscodevim.vim";
    }
    "yaml" {
      Install-VscodeExt "redhat.vscode-yaml";
    }
    Default {}

  }
}

Export-ModuleMember -Function Install-CodeExtension, Install-VscodeExt;
