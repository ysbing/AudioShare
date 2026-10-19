<#
.SYNOPSIS
Builds the Windows client and packages it for the Microsoft Store.

.DESCRIPTION
Produces build\windows\x64\runner\Release\audioshare.msix, which is the file to
drag into the Packages page in Partner Center. The package is left unsigned on
purpose: the Store signs it during certification.

The script refuses to run while identity_name or publisher still hold the
placeholder values from pubspec.yaml, because a package whose identity does not
match the Partner Center product is rejected on upload.

.EXAMPLE
./tools/package_store.ps1
.EXAMPLE
./tools/package_store.ps1 -SkipBuild

.NOTES
Under the default Restricted execution policy, start it with
'powershell -ExecutionPolicy Bypass -File tools/package_store.ps1' instead.
#>
[CmdletBinding()]
param(
  [switch]$SkipBuild,
  [string]$ClientDir = ''
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
if (-not $ClientDir) { $ClientDir = Join-Path $repoRoot 'client' }

$pubspecPath = Join-Path $ClientDir 'pubspec.yaml'
if (-not (Test-Path -LiteralPath $pubspecPath -PathType Leaf)) {
  throw "pubspec.yaml not found at '$pubspecPath'."
}

# Read the msix_config block. Parsing beats importing a YAML module, which is
# not guaranteed to be available on a stock Windows PowerShell.
$lines = Get-Content -LiteralPath $pubspecPath
$config = @{}
$inConfig = $false
foreach ($line in $lines) {
  if ($line -match '^msix_config:\s*$') { $inConfig = $true; continue }
  if ($inConfig) {
    if ($line -match '^\S') { break }
    if ($line -match '^\s+([A-Za-z_]+):\s*(.*?)\s*$') {
      $config[$Matches[1]] = $Matches[2].Trim("'`"")
    }
  }
}

$identity = $config['identity_name']
$publisher = $config['publisher']

if (-not $identity -or -not $publisher) {
  throw 'msix_config in pubspec.yaml must define identity_name and publisher.'
}
if ($identity -match '^12345' -or $publisher -match '00000000-0000-0000-0000-000000000000') {
  throw ("msix_config still contains placeholder values (identity_name='$identity', " +
         "publisher='$publisher'). Copy the real values from the product's Identity " +
         'page in Partner Center before packaging.')
}

$version = (Select-String -LiteralPath $pubspecPath -Pattern '^version:\s*([0-9.]+)\+' |
  Select-Object -First 1).Matches.Groups[1].Value
if (-not $version) { throw 'Could not read version from pubspec.yaml.' }

if (-not $SkipBuild) {
  Push-Location $ClientDir
  try {
    & flutter build windows --release
    if ($LASTEXITCODE -ne 0) { throw "flutter build windows failed with exit code $LASTEXITCODE." }
  } finally {
    Pop-Location
  }
}

Push-Location $ClientDir
try {
  & dart run msix:create
  if ($LASTEXITCODE -ne 0) { throw "msix:create failed with exit code $LASTEXITCODE." }
} finally {
  Pop-Location
}

$msix = Join-Path $ClientDir 'build\windows\x64\runner\Release\audioshare.msix'
if (-not (Test-Path -LiteralPath $msix -PathType Leaf)) {
  throw "Expected package not found at '$msix'."
}

# A package missing the bundled adb or server connects to nothing, the same
# failure that shipped in v2.1.1 (issue #8). Check the archive contents instead
# of trusting the build directory.
$required = @('audioshare.exe', 'audio_capture.dll', 'adb.exe', 'AdbWinApi.dll',
  'AdbWinUsbApi.dll', 'server')

$temp = Join-Path ([System.IO.Path]::GetTempPath()) ('audioshare-msix-' + [guid]::NewGuid())
New-Item -ItemType Directory -Path $temp | Out-Null
try {
  $zip = "$temp.zip"
  Copy-Item -LiteralPath $msix -Destination $zip
  Expand-Archive -LiteralPath $zip -DestinationPath $temp -Force
  $missing = $required | Where-Object {
    -not (Test-Path -LiteralPath (Join-Path $temp $_) -PathType Leaf)
  }
  if ($missing) {
    throw "The package is missing: $($missing -join ', '). Check client\windows\CMakeLists.txt."
  }

  $manifest = [xml](Get-Content -LiteralPath (Join-Path $temp 'AppxManifest.xml') -Raw)
  $packed = $manifest.Package.Identity
  if ($packed.Name -ne $identity) {
    throw "Package identity '$($packed.Name)' does not match msix_config identity_name '$identity'."
  }
  if ($packed.Publisher -ne $publisher) {
    throw "Package publisher '$($packed.Publisher)' does not match msix_config publisher '$publisher'."
  }
} finally {
  Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath "$temp.zip" -Force -ErrorAction SilentlyContinue
}

$size = [math]::Round((Get-Item -LiteralPath $msix).Length / 1MB, 1)
Write-Host "Store package ready: $msix ($size MB, version $version.0)"
Write-Host "Identity: $identity / $publisher"
