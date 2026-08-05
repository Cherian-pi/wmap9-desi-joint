#!/usr/bin/env bash
#
# Copy notebooks, chains, figures and BAO data from Desktop/WMAP+DESI into
# this repository. The folder structure and all text scaffolding already
# exist; this script only moves binary/asset files that had to be copied
# locally rather than written remotely.
#
# NON-DESTRUCTIVE: copies only. Nothing in WMAP+DESI is moved or deleted.
#
#   chmod +x scripts/copy_assets.sh && ./scripts/copy_assets.sh
#
set -euo pipefail

SRC="$HOME/Desktop/WMAP+DESI"
DEST="$(cd "$(dirname "$0")/.." && pwd)"

[ -d "$SRC" ] || { echo "Source not found: $SRC" >&2; exit 1; }
echo "==> Source:      $SRC"
echo "==> Destination: $DEST"

# ---------------------------------------------------------------- notebooks
echo "==> Notebooks"
cd "$SRC/Python files"
cp -a 01_data_loading_1.ipynb            "$DEST/notebooks/01_data_loading.ipynb"
cp -a 02_wmap9_lcdm_fitting.ipynb        "$DEST/notebooks/02_wmap9_lcdm.ipynb"
cp -a 03_desi_lcdm_fitting.ipynb         "$DEST/notebooks/03_desi_dr1_lcdm.ipynb"
cp -a 03.1_desi_dr1_lcdm_corrected.ipynb "$DEST/notebooks/03a_desi_dr1_lcdm_corrected.ipynb"
cp -a 03.2_desi_dr2_lcdm.ipynb           "$DEST/notebooks/03b_desi_dr2_lcdm.ipynb"
cp -a 04_wmap9_desi_joint_lcdm.ipynb     "$DEST/notebooks/04_wmap9_desi_joint_lcdm.ipynb"
cp -a 05_planck_tt_lcdm.ipynb            "$DEST/notebooks/05_planck_tt_lcdm.ipynb"
cp -a 05_planck_plik_lcdm.ipynb          "$DEST/notebooks/05a_planck_plik_lcdm.ipynb"
cp -a 05_planck_plik_lite_lcdm.ipynb     "$DEST/notebooks/05b_planck_plik_lite_lcdm.ipynb"
cp -a wmap9_wrap.pyf                     "$DEST/src/wmap9desi/wmap9_wrap.pyf"

# Deliberately NOT copied (scratch / superseded / build artifacts):
#   Untitled-1.ipynb, Untitled-1ede.ipynb, Findig the CHAINS.ipynb,
#   03_3_desi_dr1_lcdm_fixed_2.ipynb, libwmap9.so,
#   04_wmap9_desi_joint_lcdm.html, Imageswmap9_desi_joint_corner_getdist.png

# ------------------------------------------------------------------- chains
echo "==> Chains"
cd "$SRC/Python files/chains"
for f in \
  wmap9_desi_joint_chain_20260628_004948.npy \
  wmap9_desi_joint_flat_20260628_004948.npy \
  wmap9_lcdm_full_chain_20260614_235110.npy \
  wmap9_lcdm_flat_samples_20260614_235110.npy \
  wmap9_lcdm_logprob_20260614_235110.npy \
  wmap9_lcdm_meta_20260614_235110.json \
  desi_dr1_lcdm_with_rd_prior_chains.npy \
  desi_dr1_lcdm_bao_only_chains.npy \
  planck_tt_lcdm_chains.npy \
  chain_filenames.txt
do
  if [ -f "$f" ]; then cp -a "$f" "$DEST/results/chains/"; else echo "   (missing: $f)"; fi
done

# ------------------------------------------------------------------ figures
echo "==> Figures"
cd "$SRC/Images/publication"
cp -a fig1_lcdm_triangle_wmap9_vs_joint.* "$DEST/figures/publication/" 2>/dev/null || true
cp -a fig2_shared_params_three_way.*      "$DEST/figures/publication/" 2>/dev/null || true
cp -a fig3_H0_vs_Omegam.*                 "$DEST/figures/publication/" 2>/dev/null || true
cp -a fig4_Omegam_vs_densities_all.*      "$DEST/figures/publication/" 2>/dev/null || true
cp -a fig5_Omegam_vs_H0_all.*             "$DEST/figures/publication/" 2>/dev/null || true
cp -a parameter_table.tex                 "$DEST/paper/" 2>/dev/null || true

cd "$SRC/Images"
for f in gelman_rubin.png mcmc_corner_publication.png camb_vs_wmap9_sanity.png \
         desi_dr1_bao_measurements.png wmap9_tt_bandpowers.png; do
  [ -f "$f" ] && cp -a "$f" "$DEST/figures/diagnostics/"
done

# ----------------------------------------------------------------- BAO data
# bao_data/ is itself a git clone, so copy only the small DESI DR1 text files
# rather than nesting a repository inside a repository.
echo "==> DESI DR1 BAO data"
cd "$SRC/bao_data"
cp -a desi_2024_gaussian_bao_*.txt       "$DEST/data/bao/desi_dr1/" 2>/dev/null || true
cp -a desi_2024_eboss_gaussian_bao_*.txt "$DEST/data/bao/desi_dr1/" 2>/dev/null || true
[ -f README.md ] && cp -a README.md "$DEST/data/bao/desi_dr1/UPSTREAM_README.md"
if [ -d .git ]; then
  { echo "# Provenance"; echo;
    echo "Copied from a local clone of the DESI BAO likelihood data repository."; echo;
    echo "Upstream remote(s) at copy time:"; echo '```';
    git remote -v 2>/dev/null || echo "(none)";
    echo '```'; echo "Commit: $(git rev-parse --short HEAD 2>/dev/null || echo unknown)";
    echo "Copied: $(date -u +%Y-%m-%dT%H:%M:%SZ)";
  } > "$DEST/data/bao/desi_dr1/PROVENANCE.md"
fi

# --------------------------------------------------------------------- docs
echo "==> Docs"
cd "$SRC"
[ -f "Python files/symbol_note.txt" ] && cp -a "Python files/symbol_note.txt" "$DEST/docs/"
[ -f lcdm_project_tracker.html ]      && cp -a lcdm_project_tracker.html "$DEST/docs/"
[ -f wmap_file_list.txt ]             && cp -a wmap_file_list.txt "$DEST/docs/"
[ -f wmap_tt_spectrum_9yr_v5.txt ]    && cp -a wmap_tt_spectrum_9yr_v5.txt "$DEST/data/"

find "$DEST" -name '.DS_Store' -delete
chmod +x "$DEST/scripts/"*.sh

echo
echo "==> Done. Size:"
du -sh "$DEST"
echo
echo "Next:"
echo "  cd \"$DEST\""
echo "  pip install nbstripout && nbstripout --install && nbstripout notebooks/*.ipynb"
echo "  git init && git add -A && git commit -m 'Initial commit: WMAP9 + DESI DR1 joint LCDM pipeline'"
