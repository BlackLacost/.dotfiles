try {
  oh-my-posh --init --shell pwsh --config ~/scoop/apps/oh-my-posh/current/themes/star.omp.json | Invoke-Expression
}
catch {
}

Set-Alias -Name v -Value nvim
Set-Alias -Name c -Value code
Set-Alias -Name g -Value git

function cddc() { Set-Location ~/Documents; }
function cddl() { Set-Location d:/Downloads; }
function cddt() { Set-Location ~/Desktop; }
function cdd() { Set-Location ~/.dotfiles; }
function cdh() { Set-Location ~; }
function cdc() { Set-Location d:/code; }
function cdw() { Set-Location d:/code/constructor-player }
function cds() { Set-Location c:/Users/black/scoop/apps; }

function jnote() { Set-Location ~/python; jupyter notebook; }
function cr() { code -r . | Invoke-Expression; }
function nrs() { npm run start | Invoke-Expression; }
function nrd() { npm run dev | Invoke-Expression; }
function nrt() { npm run test | Invoke-Expression; }

function ghc() {
  gh repo list --limit 1000 | fzf | foreach { "gh repo clone {0}" -f ($_ -split '\t') } | Invoke-Expression
}

function gg() {
  git hist
}

function gga() {
  git hista
}

function gpush() { git push; }
function gpushf() { git push -f; }
function gpull() { git pull; }
function gfetch() { git fetch; }
function gst() { git status; }
function ga($file) {
  if ($file) {
    git add $file;
  }
  else {
    git add .;
  }
}
function gcmm($commit) {
  if ($commit) {
    git commit -m $commit;
  }
  else {
    git commit;
  }
}
function gcma($commit) {
  if ($commit) {
    git commit --amend -m $commit;
  }
  else {
    git commit --amend --no-edit;
  }
}
function gacmm($commit) { git add .; gcmm($commit); }
function gacma($commit) { git add .; gcma($commit); }
function gdiff($file) { git diff HEAD $file; }
function gdiffc($file) { git diff HEAD $file --cached; }

function Compare-GitFiles {
  param (
    $File
  )

  if ($File) {
    git diff HEAD $File
  }
  else {
    git diff HEAD
  }
}
Set-Alias -Name ggd -Value Compare-GitFiles

function Get-GitLog {
  param (
    [bool]$All = $false
  )

  if ($All) {
    git log `
      --graph `
      --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' `
      --abbrev-commit `
      --all
  }
  else {
    git log `
      --graph `
      --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' `
      --abbrev-commit `

  }
}
Set-Alias -Name glg -Value Get-GitLog

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
