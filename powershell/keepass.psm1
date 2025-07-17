# $Pass = null;
# $Keepassdb = null;

function Get-KeypassAttr {
  [CmdletBinding()]
  [OutputType([String])]
  param (
    [Parameter(Mandatory = $true)]
    [String] $Record,

    [Parameter(Mandatory = $true)]
    [ValidateSet('Title', 'UserName', 'Password', 'URL', 'Notes')]
    [String] $Attr
  )
  $SecurePass = Read-Host -AsSecureString -Prompt "Enter password"

  $ptr = [Security.SecureStringMarshal]::SecureStringToCoTaskMemAnsi($SecurePass);
  $Pass = [Runtime.InteropServices.Marshal]::PtrToStringAnsi($ptr);
  # TODO Check database file exist
  $DbPath = "$HOME\.dotfiles\auth\passwords.kdbx";
  if (-not (Test-Path -Path "$DbPath")) {
    throw "Keepass db not exist for this path: $DbPath";
  }
  #! keepassxc-cli displays the "enter password" promt into stderr and
  #  powershell throws the NativeCommandError exception if program output
  #  to stderr (redirect does not help).
  $ErrorActionPreference = "SilentlyContinue";
  $ret = $null;
  # -s to show protected attribute (password) as clear text.
  $ret = $(
    Write-Output $Pass |
    keepassxc-cli show -s $Keepassdb $Record --attributes $Attr
  );
  $ErrorActionPreference = "Stop";
  if (-not $?) { throw "keepassxc-cli failed" }
  return $ret;
}

# function Get-KeePassEntry {
#   param (
#     [string]$Database,
#     [string]$Username,
#     [string]$Title
#   )

#   # Вызов keepassxc-cli
#   $output = & keepassxc-cli show -f "$Database" --username "$Username" --title "$Title"

#   # Регулярное выражение для извлечения нужных полей
#   $pattern = @'
#     Title:\s*(.+)
#     UserName:\s*(.+)
#     Password:\s*(.+)
#     URL:\s*(.*)
#     Notes:\s*(.*)
#     Uuid:\s*({.*})
#     Tags:\s*(.*)
# '@

#   if ($output -match $pattern) {
#     return @{
#       Title    = $matches[1]
#       UserName = $matches[2]
#       Password = $matches[3]
#       URL      = $matches[4]
#       Notes    = $matches[5]
#       Uuid     = $matches[6]
#       Tags     = $matches[7]
#     }
#   }
#   else {
#     throw "Не удалось найти запись в базе."
#   }
# }

# function Ask-ForCredentials {
#   $SecurePass = Read-Host -AsSecureString -Prompt "Enter password"

#   $ptr = [Security.SecureStringMarshal]::SecureStringToCoTaskMemAnsi($SecurePass);
#   $Pass = [Runtime.InteropServices.Marshal]::PtrToStringAnsi($ptr);
#   $Keepassdb = $this._path(@($this._cfgDir, "auth/passwords.kdbx"));

#   $this._github.user = $this._attrFromKeepass("github", "username");
#   $this._github.pass = $this._attrFromKeepass("github", "password");
#   $this._github.token = $this._attrFromKeepass("github", "auto-cfg-token");

#   $this._mqtt.url = $this._attrFromKeepass("hivemq", "login_url");
#   $this._mqtt.user = $this._attrFromKeepass("hivemq", "login_user");
#   $this._mqtt.pass = $this._attrFromKeepass("hivemq", "login_pass");

#   $record = "vk.gvp-url-shortener";
#   $this._vk.cc_token = $this._attrFromKeepass($record, "token");
# }


# _uploadSshKey() {
#   $marker = ".uploaded_to_github";
#   if (Test-Path -Path $this._path(@("~", ".ssh", "$marker"))) { return; }

#   $pair = "$($this._github.user):$($this._github.token)";
#   $bytes = [System.Text.Encoding]::ASCII.GetBytes($pair);
#   $creds = [System.Convert]::ToBase64String($bytes)
#   $headers = @{Authorization = "Basic $creds"; }
#   $body = ConvertTo-Json @{
#     title = "box key $(Get-Date)";
#     key   = (Get-Content "~/.ssh/id_rsa.pub" | Out-String);
#   }
#   $url = "https://api.github.com/user/keys"
#   if (-not $this._isTest) {
#     try {
#       Invoke-WebRequest -Method 'POST' -Headers $headers -Body $body $url;
#     }
#     catch {
#       if ($_.Exception.Response.StatusCode -eq 422) {
#         Write-Host "ssh key already added to GitHub";
#         New-File -Path .ssh -Name $marker;
#       }
#       elseif ($_.Exception.Response.StatusCode -eq 401) {
#         # TODO: try to upload via auth token.
#         Write-Host "Failed to add key to GitHub";
#         Write-Host "Upload manually and touch .ssh/${marker}";
#         Write-Host "Login: '$($this._github.user)'";
#         Write-Host "Pass: '$($this._github.pass)'";
#         Write-Host "REBOOT IF FIRST INSTALL (to correctly install WSL)";
#         throw "Failed";
#       }
#       else {
#         throw "Failed $($_.Exception)";
#       }
#     }
#     New-File -Path "~/.ssh" -Name $marker;
#   }
# }
