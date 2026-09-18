#!/usr/bin/env bash
set -euo pipefail
rm -rf app
mkdir -p app
base64 -d lycraform-src.tar.gz.b64 | tar -xz -C app
cd app
npm install
npm run build
