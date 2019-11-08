try {
  Import-Module posh-git;
}
catch {
}

function cdd() { Set-Location ~/Documents; }
function cdc() { Set-Location ~/.dotfiles; }
function cdh() { Set-Location ~; }
function cdp() { Set-Location D:/code; }

# Windows-OSX-Linux consistency
function rmf($dst) {
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
(& "C:\Users\blacklacost\Miniconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
#endregion
