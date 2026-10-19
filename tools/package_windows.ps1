<#
.SYNOPSIS
Packages the built Windows client into a release archive.

.DESCRIPTION
Validates that the build output contains every file AudioShare loads at runtime
and then zips the whole Release directory. It refuses to produce an archive
when something is missing, because a package without the bundled adb files or
the Android server stalls on "Connecting" (issue #8).

.EXAMPLE
./tools/package_windows.ps1
.EXAMPLE
./tools/package_windows.ps1 -Version 2.1.2

.NOTES
Under the default Restricted execution policy, start it with
'powershell -ExecutionPolicy Bypass -File tools/package_windows.ps1' instead.
#>
[CmdletBinding()]
param(
  [string]$Version = '',
  [string]$ReleaseDir = (Join-Path $PSScriptRoot '..\client\build\windows\x64\runner\Release'),
  [string]$OutputDir = (Join-Path $PSScriptRoot '..\dist')
)

$ErrorActionPreference = 'Stop'

# Loaded from the directory next to the executable by adb_service.dart and
# audio_capture.dart; the rest of the bundle is copied as-is.
$required = @(
  'audioshare.exe',
  'audio_capture.dll',
  'adb.exe',
  'AdbWinApi.dll',
  'AdbWinUsbApi.dll',
  'server'
)

if (-not $Version) {
  # Derive the version from the latest tag; fall back to 'dev' without git.
  $Version = try { (git describe --tags --abbrev=0 2>$null) -replace '^v', '' } catch { '' }
  if (-not $Version) { $Version = 'dev' }
}

if (-not (Test-Path -LiteralPath $ReleaseDir -PathType Container)) {
  throw "Build output not found at '$ReleaseDir'. Run 'flutter build windows --release' first."
}
$releasePath = (Resolve-Path -LiteralPath $ReleaseDir).Path

$missing = $required | Where-Object {
  -not (Test-Path -LiteralPath (Join-Path $releasePath $_) -PathType Leaf)
}
if ($missing) {
  throw "Incomplete build output in '$releasePath'. Missing: $($missing -join ', '). " +
        'Run the gradle :server:assembleRelease task to refresh client\assets, then rebuild the client.'
}

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
$zipPath = Join-Path (Resolve-Path -LiteralPath $OutputDir).Path "audioshare-$Version-win.zip"
Remove-Item -LiteralPath $zipPath -Force -ErrorAction SilentlyContinue

# Existing release assets are .7z; zip keeps this script dependency-free, so
# swap in 7z here if the old asset naming has to be kept.
Compress-Archive -Path (Join-Path $releasePath '*') -DestinationPath $zipPath -CompressionLevel Optimal

Write-Host "Packaged $(Split-Path -Leaf $zipPath) ($([math]::Round((Get-Item -LiteralPath $zipPath).Length / 1MB, 1)) MB)"
