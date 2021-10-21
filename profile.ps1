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
function ggl { git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit; }
function ggp { git push; }

function touch($file) { "" | Out-File $file }

function ftask($port) {
  netstat -ano | findstr :$port
}
function ktask($taskPid) {
  taskkill /PID $taskPid /F
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

$PSReadLineOptions = @{
  EditMode = "Vi"
  HistoryNoDuplicates = $true
  HistorySearchCursorMovesToEnd = $true
  ViModeIndicator = "Prompt"
}
Set-PSReadLineOption @PSReadLineOptions

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
# (& "conda" "shell.powershell" "hook") | Out-String | Invoke-Expression
#endregion
