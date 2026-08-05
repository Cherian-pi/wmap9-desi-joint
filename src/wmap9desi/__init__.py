"""WMAP9 + DESI DR1 joint ΛCDM pipeline.

Modules to be extracted from notebook 04:

    wmap9.py    ctypes wrapper around libwmap9.so
    bao.py      DESI DR1 Gaussian BAO likelihood, per-tracer row ordering
    theory.py   CAMB theory spectrum and distance calculations
    sampling.py emcee driver, priors, chain I/O
    plotting.py GetDist / corner figure helpers
"""

__version__ = "0.1.0"
