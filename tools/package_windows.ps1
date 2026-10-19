<#
.SYNOPSIS
Packages the built Windows client into a release archive.

.DESCRIPTION
Validates that the build output contains every file AudioShare loads at runtime
and then archives the whole Release directory as audioshare-<version>-win.7z
(.zip when 7-Zip is not installed). It refuses to produce an archive when
something is missing, because a package without the bundled adb files or the
Android server stalls on "Connecting" (issue #8).

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
  [string]$ReleaseDir = '',
  [string]$OutputDir = ''
)

$ErrorActionPreference = 'Stop'

# $PSScriptRoot is not available while evaluating param() defaults, so resolve
# the repository defaults here.
$repoRoot = Split-Path -Parent $PSScriptRoot
if (-not $ReleaseDir) { $ReleaseDir = Join-Path $repoRoot 'client\build\windows\x64\runner\Release' }
if (-not $OutputDir) { $OutputDir = Join-Path $repoRoot 'dist' }

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
$outPath = (Resolve-Path -LiteralPath $OutputDir).Path

# Release assets are .7z, so use 7-Zip when it is installed and fall back to the
# built-in zip support otherwise.
$sevenZip = @(
  "$env:ProgramFiles\7-Zip\7z.exe",
  "${env:ProgramFiles(x86)}\7-Zip\7z.exe"
) | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1

if ($sevenZip) {
  $archive = Join-Path $outPath "audioshare-$Version-win.7z"
  Remove-Item -LiteralPath $archive -Force -ErrorAction SilentlyContinue
  & $sevenZip a -t7z -mx=9 -bso0 -bsp0 $archive (Join-Path $releasePath '*')
  if ($LASTEXITCODE -ne 0) { throw "7-Zip failed with exit code $LASTEXITCODE." }
} else {
  $archive = Join-Path $outPath "audioshare-$Version-win.zip"
  Remove-Item -LiteralPath $archive -Force -ErrorAction SilentlyContinue
  Compress-Archive -Path (Join-Path $releasePath '*') -DestinationPath $archive -CompressionLevel Optimal
}

Write-Host "Packaged $(Split-Path -Leaf $archive) ($([math]::Round((Get-Item -LiteralPath $archive).Length / 1MB, 1)) MB)"
