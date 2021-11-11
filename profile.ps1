try {
  Import-Module posh-git;
}
catch {
}
function cddc() { Set-Location ~/Documents; }
function cddl() { Set-Location ~/Downloads; }
function cddt() { Set-Location ~/Desktop; }
function cdd() { Set-Location ~/.dotfiles; }
function cdh() { Set-Location ~; }
function cdp() { Set-Location D:/code; }
function cdx() { Set-Location ~/.xi; }
function jnote() { Set-Location ~/python; jupyter notebook; }
function webp() { cdp; cd web-playground; code .; }

function g($command) { git $command; }
function ggs() { git status; }
function gga($file) {
  if ($file) {
    git add $file;
  } else {
    git add .;
  }
}
function ggc($commit) {
  if ($commit) {
    git commit -m $commit;
  } else {
    git commit;
  }
}
function ggac($commit) { git add .; ggc($commit); }
function ggca($commit) {
  if ($commit) {
    git commit --amend -m $commit;
  } else {
    git commit --amend --no-edit;
  }
}
function ggaca($commit) { git add .; ggca($commit); }
function ggd($file) { git diff HEAD $file; }

function Read-GitLog {
  param (
    [bool]$All = $false
  )

  if ($All) {
    git log `
      --graph `
      --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' `
      --abbrev-commit `
      --all
  } else {
    git log `
      --graph `
      --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' `
      --abbrev-commit `
      --all
  }
}
Set-Alias -Name ggl -Value Read-GitLog

function Push-Git {
  git push;
}
Set-Alias -Name ggp -Value Push-Git

function touch($file) { "" | Out-File $file }

function Find-TaskPid {
  param (
    $TaskPort
  )
  netstat -ano | findstr :$TaskPort
}
function Close-Task {
  param (
    $TaskPid
  )
  taskkill /PID $TaskPid /F
}

# Reload the Shell
function Reload-Powershell {
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
    $newProcess.Arguments = "-nologo";
    [System.Diagnostics.Process]::Start($newProcess);
    exit
}

# Windows-OSX-Linux consistency
function rmd($dst) {
  Remove-Item $dst -Recurse -Force
}

# Windows-OSX-Linux consistency
function ll($dst) {
  Get-ChildItem $dst
}

function Set-Proxy {
  param (
    $ProxyScriptUrl = 'https://antizapret.prostovpn.org/proxy.pac'
  )
  Set-ItemProperty `
    -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' `
    -Name 'AutoConfigURL' `
    -Value $ProxyScriptUrl
  Write-Output "Установлен proxy script $ProxyScriptUrl"
}

function Get-Proxy {
  Get-ItemProperty `
    -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' `
    -Name 'AutoConfigURL' `
    | Select-Object "AutoConfigURL"
}
function OnViModeChange {
  if ($args[0] -eq 'Command') {
      # Set the cursor to a blinking block.
      Write-Host -NoNewLine "`e[1 q"
  } else {
      # Set the cursor to a blinking line.
      Write-Host -NoNewLine "`e[5 q"
  }
}

$PSReadLineOptions = @{
  EditMode = "Vi"
  HistoryNoDuplicates = $true
  HistorySearchCursorMovesToEnd = $true
  ViModeIndicator = "Script"
  ViModeChangeHandler = $Function:OnViModeChange
}
Set-PSReadLineOption @PSReadLineOptions
Write-Host -NoNewLine "`e[5 q"

# GitHub Cli autocomplete
Invoke-Expression -Command $(gh completion -s powershell | Out-String)

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
# (& "conda" "shell.powershell" "hook") | Out-String | Invoke-Expression
#endregion
