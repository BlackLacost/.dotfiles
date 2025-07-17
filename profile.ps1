try {
  oh-my-posh --init --shell pwsh --config ~/scoop/apps/oh-my-posh/current/themes/star.omp.json | Invoke-Expression
}
catch {
}

Set-Alias -Name v -Value nvim
Set-Alias -Name c -Value code

Set-Alias -Name g -Value git
# TODO: Git aliases from https://github.com/gluons/powershell-git-aliases/blob/master/src/aliases.ps1
function gsw {
  git switch $args
}
function gswc {
  git switch --create $args
}
function gbc {
  git branch --show-current
}

function cdd() { Set-Location ~/.dotfiles; }
function cdh() { Set-Location ~; }
function cdc() { Set-Location d:/code; }
function cr() { code -r . | Invoke-Expression; }
function nrs() { npm run start | Invoke-Expression; }
function nrd() { npm run dev | Invoke-Expression; }
function nrt() { npm run test | Invoke-Expression; }

function ghc() {
  gh repo list --limit 1000 | fzf | foreach { "gh repo clone {0}" -f ($_ -split '\t') } | Invoke-Expression
}

function Find-TaskPidByPort {
  param (
    $TaskPort
  )
  # -a Отображение всех подключений и портов прослушивания
  # -n Отображение адресов и номеров портов в числовом формате
  # -o Отображение ИД процесса каждого подключения
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

function rmd() {
  Remove-Item -Recurse -Force $args;
}

function OnViModeChange {
  if ($args[0] -eq 'Command') {
    # Set the cursor to a blinking block.
    Write-Host -NoNewLine "`e[1 q"
  }
  else {
    # Set the cursor to a blinking line.
    Write-Host -NoNewLine "`e[5 q"
  }
}

$PSReadLineOptions = @{
  EditMode                      = "Windows" # Emacs or Vi or Windows
  HistoryNoDuplicates           = $true
  HistorySearchCursorMovesToEnd = $true
  ViModeIndicator               = "Script"
  ViModeChangeHandler           = $Function:OnViModeChange
}
Set-PSReadLineOption @PSReadLineOptions
Write-Host -NoNewLine "`e[5 q"

# GitHub Cli autocomplete
if (Get-Command gh -ErrorAction SilentlyContinue) {
  Invoke-Expression -Command $(gh completion -s powershell | Out-String)
}

Import-Module posh-git
