#!/usr/bin/env bash
#
# Compile the WMAP9 Fortran likelihood into a shared library that the
# ctypes wrapper in src/wmap9desi/ can load.
#
# Requires gfortran and cfitsio. On macOS:
#   brew install gcc cfitsio
#
set -euo pipefail
cd "$(dirname "$0")/.."

SRC="external/wmap_likelihood_v5"
if [ ! -d "$SRC" ]; then
  echo "Missing $SRC — run ./scripts/fetch_wmap_likelihood.sh first." >&2
  exit 1
fi

echo "==> Building in $SRC"
echo "TODO: paste the exact gfortran / make invocation that produced your"
echo "      working libwmap9.so, including the -I and -L paths for cfitsio."
echo
echo "The Makefile shipped with the likelihood builds a static test binary;"
echo "the shared-object build needs -fPIC throughout plus an explicit"
echo "-shared link step. Record the working command here so the build is"
echo "reproducible on another machine."
exit 1
