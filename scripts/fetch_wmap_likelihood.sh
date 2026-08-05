#!/usr/bin/env bash
#
# Fetch the WMAP nine-year likelihood code + data into external/.
# These are ~1 GB and are not redistributed in this repository.
#
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p external && cd external

# NOTE: verify this URL against
# https://lambda.gsfc.nasa.gov/product/map/dr5/likelihood_get.html
# LAMBDA has reorganised these paths before.
BASE="https://lambda.gsfc.nasa.gov/data/map/dr5/dcp/likelihood"
TARBALL="wmap_likelihood_full_v5.tar.gz"

if [ -d wmap_likelihood_v5 ]; then
  echo "external/wmap_likelihood_v5 already present — nothing to do."
  exit 0
fi

echo "==> Downloading $TARBALL from NASA LAMBDA"
curl -fL -O "$BASE/$TARBALL"

echo "==> Extracting"
tar xzf "$TARBALL"
rm -f "$TARBALL"

echo "==> Done. Verify the data products are present:"
ls -1 wmap_likelihood_v5/data
