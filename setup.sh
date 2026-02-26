#!/bin/bash

conda --version > /dev/null 2>&1 || { echo "✗ This environment setup script requires conda"; exit 1; }

set -e

conda create -yn digging_in

source activate digging_in

conda install -yc conda-forge \
    r-base=4.3.3 \
    r-matrix=1.6.1 \
    r-lme4=1.1.35 \
    r-tidyverse=2.0.0 \
    r-rcpp=1.0.14 \
    r-rcppeigen=0.3.4.0.0 \
    r-nloptr=2.0.3 \
    r-minqa=1.2.6 \
    r-mass=7.3_60 \
    r-rstan=2.32.6 \
    r-stanheaders=2.32.10 \
    r-brms=2.22.0 \
    r-bayestestr=0.15.2 \
    clang=20.1.1 \
    llvm-openmp=20.1.1 \
    gfortran=13.3.0 \
    r-lmertest=3.1.3 \
    r-ggpubr=0.6.0 \
    r-future=1.49.0 \
    r-ggpattern=1.2.1 \
    r-here=1.0.1

# Note: You may see two types of errors during installation:
# - SafetyError for r-base (R updates its package index)
# - ClobberErrors for compilers sharing paths
# These are non-blocking and should not affect functionality.

echo "Verifying R installation..."
R --version > /dev/null 2>&1 || { echo "✗ R installation failed"; exit 1; }
echo "✓ R installed successfully"

echo "Testing core packages..."
R --quiet --no-save -e "
packages <- c('here', 'tidyverse', 'lme4', 'lmerTest', 'brms', 'bayestestR', 'future')
for(pkg in packages) {
  if(!require(pkg, character.only=TRUE)) {
    stop()
  }
}
" > /dev/null 2>&1 && echo "✓ All packages loaded successfully" || { echo "✗ Package verification failed"; exit 1; }

echo "✓ Environment created successfully. Activate with: conda activate digging_in"