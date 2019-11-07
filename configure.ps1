class App {

  $_cfgDir = $null;

  configure() {
    $this._cfgDir = "$($env:USERPROFILE)\.dotfiles";

    $this._configureVscode();
  }

  _configureVscode() {
    $dstDir = "$($env:APPDATA)\Code\User";

    # Создавать директорию, только если ее ещё не было
    if (-not (Test-Path -Path $dstDir)) {
      New-Item -Path $dstDir -ItemType Directory | Out-Null;
    }

    $srcPath = "$($this._cfgDir)\vscode_settings.json";
    $dstPath = "$dstDir\settings.json";
    New-Item -ItemType SymbolicLink -Path $dstPath -Target $srcPath -Force;

    $srcPath = "$($this._cfgDir)\vscode_keybindings.json";
    $dstPath = "$dstDir\keybindings.json";
    New-Item -ItemType SymbolicLink -Path $dstPath -Target $srcPath -Force;
  }

}

$app = [App]::new();
$app.configure();
