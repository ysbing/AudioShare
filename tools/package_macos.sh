#!/usr/bin/env bash
#
# Packages the built macOS client into a release archive.
#
# Validates that the app bundle contains every file AudioShare loads at runtime
# and then zips it as audioshare-<version>-macos.zip. The bundle is code signed
# before archiving: ad-hoc by default, which is enough to run the app locally,
# or with a real identity for distribution.
#
# Usage:
#   ./tools/package_macos.sh
#   ./tools/package_macos.sh --version 2.2.2
#   ./tools/package_macos.sh --identity "Developer ID Application: ..."

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

app="$repo_root/client/build/macos/Build/Products/Release/AudioShare.app"
out="$repo_root/dist"
version=""
identity="-"

usage() {
  cat <<'EOF'
Usage: package_macos.sh [options]

Options:
  --version <version>   Version used in the archive name (default: pubspec.yaml).
  --app <path>          Path to AudioShare.app (default: the Release build).
  --output <dir>        Directory for the archive (default: dist).
  --identity <name>     codesign identity (default: "-" for ad-hoc signing).
  -h, --help            Show this help.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version) version="$2"; shift 2 ;;
    --app) app="$2"; shift 2 ;;
    --output) out="$2"; shift 2 ;;
    --identity) identity="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 1 ;;
  esac
done

if [[ -z "$version" ]]; then
  version="$(sed -n 's/^version:[[:space:]]*\([0-9][0-9.]*\)+.*/\1/p' "$repo_root/client/pubspec.yaml" | head -n 1)"
  [[ -n "$version" ]] || version="dev"
fi

if [[ ! -d "$app" ]]; then
  echo "Build output not found at '$app'. Run 'flutter build macos --release' first." >&2
  exit 1
fi

# Loaded by adb_service.dart and audio_capture.dart at runtime. A package
# without the bundled adb or server stalls on "Connecting" (issue #8).
required=(
  "Contents/MacOS/AudioShare"
  "Contents/MacOS/adb"
  "Contents/MacOS/audio_capture.dylib"
  "Contents/Resources/server"
  "Contents/Resources/flutter_assets"
)

missing=""
for path in "${required[@]}"; do
  if [[ ! -e "$app/$path" ]]; then
    missing="${missing}${missing:+, }$path"
  fi
done
if [[ -n "$missing" ]]; then
  echo "Incomplete app bundle at '$app'. Missing: $missing" >&2
  echo "Run the gradle :server:assembleRelease task to refresh client/assets, then rebuild the client." >&2
  exit 1
fi

chmod +x "$app/Contents/MacOS/adb"

if [[ "$identity" == "-" ]]; then
  codesign --force --deep --sign - "$app"
else
  codesign --force --deep --sign "$identity" --options runtime --timestamp "$app"
fi
codesign --verify --deep --strict "$app"

mkdir -p "$out"
archive="$out/audioshare-$version-macos.zip"
rm -f "$archive"
# ditto keeps symlinks and permissions intact, which a plain zip does not.
ditto -c -k --sequesterRsrc --keepParent "$app" "$archive"

size="$(du -h "$archive" | cut -f 1)"
echo "Packaged $(basename "$archive") ($size)"
