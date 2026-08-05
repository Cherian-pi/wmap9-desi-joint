# WMAP9 + DESI DR1: a Planck-independent joint ΛCDM constraint

A reproducible MCMC pipeline that combines the WMAP nine-year CMB temperature
likelihood with DESI DR1 baryon acoustic oscillation measurements, deliberately
without Planck, to obtain an independent set of flat-ΛCDM parameter constraints.

**Author:** Cherian Parangot Ittyipe · [github.com/Cherian-pi](https://github.com/Cherian-pi)

---

## Results

Joint WMAP9 + DESI DR1 flat ΛCDM (32 walkers, Gelman–Rubin R̂ < 1.002):

| Parameter | Joint constraint |
|---|---|
| $H_0$ | 67.41 ± 0.53 km s⁻¹ Mpc⁻¹ |
| $Ω_m$ | 0.3069 ± 0.0063 |

Adding DESI BAO to WMAP9 collapses the CMB-only geometric degeneracy: the long
$Ω_m–H_0$ ridge in the WMAP9-alone posterior shrinks to a compact contour
(`fig4`), tightening H₀ by roughly a factor of three while shifting it downward
by about 2 km s⁻¹ Mpc⁻¹. No Planck r_d prior is used anywhere — WMAP9 calibrates
the sound horizon through the acoustic peaks itself.

## Figures

All in `figures/publication/`, each as both PDF and PNG. Every panel compares
WMAP9 alone against the WMAP9 + DESI DR1 joint posterior.

| Figure | Content |
|---|---|
| `fig1_lcdm_triangle_wmap9_vs_joint` | Full six-parameter triangle: Ω_b h², Ω_c h², H₀, n_s, ln10¹⁰A_s, τ |
| `fig2_shared_params` | The four parameters BAO can inform: Ω_b h², Ω_c h², H₀, Ω_m |
| `fig3_Omegam_vs_densities_wmap9_joint` | Ω_m against the physical densities |
| `fig4_Omegam_vs_H0_wmap9_joint` | The Ω_m–H₀ plane — the clearest single view of what BAO adds |

`figures/diagnostics/` holds convergence and sanity checks: Gelman–Rubin
statistics, the CAMB-vs-WMAP9 spectrum comparison, and the input bandpowers.

## The Lyman-α row-ordering issue

DESI DR1 stores its anisotropic BAO measurements in a per-tracer row order that
is **not uniform across tracers**:

- LRG1, LRG2, LRG3+ELG1, ELG2 → `DM_over_rs` first, then `DH_over_rs`
- **Lyman-α → `DH_over_rs` first, then `DM_over_rs`**
- BGS and QSO → isotropic, a single `DV_over_rs` row

A loader that assigns by row position rather than by the label column therefore
transposes the two Lyman-α observables against the covariance matrix, inflating
the DESI χ². The mean files must be read by their quantity label. Notebook
`03_desi_dr1_lcdm_corrected.ipynb` documents the diagnosis and the before/after
comparison.

## Layout

```
notebooks/      01 data loading → 02 WMAP9 alone → 03 DESI DR1 (ordering audit) → 04 joint fit
src/wmap9desi/  importable pipeline (in progress; currently the f2py interface file only)
data/bao/       DESI DR1 mean + covariance files (see PROVENANCE.md)
data/           WMAP9 nine-year TT spectrum
external/       gitignored; third-party likelihood codes are fetched here
scripts/        fetch and build helpers for the WMAP9 likelihood
results/chains/ production emcee chains (.npy) and run metadata (.json)
figures/        publication figures and MCMC diagnostics
paper/          parameter table and manuscript source
docs/           notes and symbol conventions
```

## Setup

```bash
git clone https://github.com/Cherian-pi/wmap9-desi-joint.git
cd wmap9-desi-joint
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt

# fetch and build the WMAP9 likelihood (not redistributed here)
./scripts/fetch_wmap_likelihood.sh
./scripts/build_libwmap9.sh
```

The WMAP nine-year likelihood code and its data products (~1 GB) are not
committed. They are downloaded from NASA LAMBDA into `external/`, which is
gitignored, and compiled into `libwmap9.so` locally — the shared object is
platform-specific and is also not committed.

## Method

CAMB supplies the theory TT spectrum; the WMAP9 Fortran likelihood is called
through a ctypes wrapper around `libwmap9.so`; DESI BAO enters as a Gaussian
likelihood on the tracer-wise distance ratios. Sampling uses `emcee` with
`DEMove`; posteriors are plotted with GetDist and corner.

## Scope

This repository covers WMAP9-alone and WMAP9 + DESI DR1 joint constraints only.
DESI-alone fits, Planck likelihood work, and DESI DR2 exploration are
deliberately out of scope.

## Citation

If you use this code, please cite the accompanying manuscript (in preparation)
and the underlying data releases: WMAP nine-year (Bennett et al. 2013,
Hinshaw et al. 2013) and DESI DR1 BAO (DESI Collaboration 2024).

## License

Code: MIT (see `LICENSE`). WMAP and DESI data products remain under the terms
set by their respective collaborations.
