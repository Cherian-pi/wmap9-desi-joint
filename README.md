# WMAP9 + DESI DR1: a Planck-independent joint ΛCDM constraint

A reproducible MCMC pipeline that combines the WMAP nine-year CMB temperature
likelihood with DESI DR1 baryon acoustic oscillation measurements, deliberately
without Planck, to obtain an independent set of flat-ΛCDM parameter constraints.

**Author:** Cherian Parangot Ittyipe · [github.com/Cherian-pi](https://github.com/Cherian-pi)

---

## Results

Joint WMAP9 + DESI DR1 flat ΛCDM (32 walkers, 1000 steps, 30 400 post-burn-in
samples, Gelman–Rubin R̂ < 1.002):

| Parameter | Joint constraint |
|---|---|
| H₀ | 67.41 ± 0.53 km s⁻¹ Mpc⁻¹ |
| Ω_m | 0.3069 ± 0.0063 |

DESI DR1 BAO alone, with an r_d prior:

| Parameter | Value |
|---|---|
| Ω_b h² | 0.02281 ± 0.00075 |
| Ω_c h² | 0.1182 ± 0.0031 |
| Ω_m | 0.2960 ± 0.0085 |

Figures reproducing these are in `figures/publication/`.

## The Lyman-α row-ordering issue

DESI DR1 stores its anisotropic BAO measurements in a per-tracer row order that
is **not uniform across tracers**:

- LRG1, LRG2, LRG3+ELG1, ELG2 → `DM/r_d` first, then `DH/r_d`
- **Lyman-α → `DH/r_d` first, then `DM/r_d`**
- BGS and QSO → isotropic, a single `DV/r_d` row

Assuming the majority ordering for the Lyman-α tracer transposes its two
observables against the covariance matrix and inflates the DESI
log-likelihood χ². The ordering is handled explicitly per tracer in
`src/wmap9desi/bao.py`; see the `03a_*` notebook for the before/after
comparison.

## Layout

```
notebooks/      numbered analysis notebooks, 01 (data) → 05 (Planck cross-check)
src/wmap9desi/  importable pipeline: WMAP9 ctypes wrapper, BAO likelihood, theory, plotting
data/bao/       small DESI DR1 mean + covariance files (see PROVENANCE.md)
external/       gitignored; third-party likelihood codes are fetched here
scripts/        fetch and build helpers for the WMAP9 likelihood
results/chains/ production emcee chains (.npy) and run metadata (.json)
figures/        publication figures and MCMC diagnostics
paper/          manuscript source
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

## Citation

If you use this code, please cite the accompanying manuscript (in preparation)
and the underlying data releases: WMAP nine-year (Bennett et al. 2013,
Hinshaw et al. 2013) and DESI DR1 BAO (DESI Collaboration 2024).

## License

Code: MIT (see `LICENSE`). WMAP and DESI data products remain under the terms
set by their respective collaborations.
