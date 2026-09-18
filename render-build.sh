#!/usr/bin/env bash
set -euo pipefail

rm -rf app source.b64 overrides.b64
mkdir -p app

cat lycraform-part-00 lycraform-part-01 lycraform-part-02 lycraform-part-03 lycraform-part-04 lycraform-part-05 > source.b64
SOURCE_SHA="$(sha256sum source.b64 | awk '{print $1}')"
EXPECTED_SOURCE_SHA="4184956f67d960c6dc52e219000137a8f759d7af06e1bce7e72497bb4dcff426"
if [ "$SOURCE_SHA" != "$EXPECTED_SOURCE_SHA" ]; then
  echo "Base source transport checksum mismatch: $SOURCE_SHA"
  exit 1
fi
base64 -d source.b64 | tar -xz -C app

cat lycraform-override-part-00 lycraform-override-part-01 > overrides.b64
OVERRIDE_SHA="$(sha256sum overrides.b64 | awk '{print $1}')"
EXPECTED_OVERRIDE_SHA="f6c976712fc62f20b4c5693640fb50b2fab3d0009d1013f842edf44468d50258"
if [ "$OVERRIDE_SHA" != "$EXPECTED_OVERRIDE_SHA" ]; then
  echo "Repair override checksum mismatch: $OVERRIDE_SHA"
  exit 1
fi
base64 -d overrides.b64 | tar -xz -C app

cd app
npm install
npm run build
