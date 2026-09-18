#!/usr/bin/env bash
set -euo pipefail
rm -rf app source.b64
mkdir -p app
cat lycraform-part-00 lycraform-part-01 lycraform-part-02 lycraform-part-03 lycraform-part-04 lycraform-part-05 > source.b64
ACTUAL_SHA="$(sha256sum source.b64 | awk '{print $1}')"
EXPECTED_SHA="4184956f67d960c6dc52e219000137a8f759d7af06e1bce7e72497bb4dcff426"
if [ "$ACTUAL_SHA" != "$EXPECTED_SHA" ]; then
  echo "Source transport checksum mismatch: $ACTUAL_SHA"
  exit 1
fi
base64 -d source.b64 | tar -xz -C app
cd app
# R3F 9.7.0 currently peers React >=19 <19.3. Next 16 supports React 19.2.
sed -i 's/"react": "19.3.0"/"react": "19.2.0"/' package.json
sed -i 's/"react-dom": "19.3.0"/"react-dom": "19.2.0"/' package.json
npm install
npm run build
