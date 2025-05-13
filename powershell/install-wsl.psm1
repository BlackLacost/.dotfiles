function Install-Wsl {
  [CmdletBinding()]
  param ()

  Write-Host "Installing WSL";

  & wsl --status;
  if ($LASTEXITCODE -eq 0) {
    if (Test-Path -Path "\\wsl$\Ubuntu") {
      Write-Host "WSL is already installed";
      # $wslSshDir = "\\wsl$\Ubuntu\home\ilya\.ssh"
      # if (Test-Path -Path "$wslSshDir" ) {
      #   Write-Host "Keys are already copied to WSL"
      #   return;
      # }
      # else {
      #   Write-Host "Creating wsl://~/.ssh";
      #   New-Dir -Path "$wslSshDir";
      #   Write-Host "Copying keys to wsl://~/.ssh";
      #   $srcPath = $this._path(@("~", ".ssh", "id_rsa"))
      #   Copy-Item -Path "$srcPath" -Destination "$wslSshDir" -Force;
      #   $srcPath = $this._path(@("~", ".ssh", "id_rsa.pub"))
      #   Copy-Item -Path "$srcPath" -Destination "$wslSshDir" -Force;
      #   & wsl chmod 600 ~/.ssh/id_rsa
      #   return;
      # }
    }
    else {
      # Need to be install two times: before and after reboot
      Write-Host "Installing WSL. Create a 'user' user with a password";
      Start-Process wsl -ArgumentList "--install" -Wait;
      return;
    }
  }
  else {
    Start-Process wsl -ArgumentList "--install" -Wait;
    return;
  }
}

Export-ModuleMember -Function Install-Wsl;