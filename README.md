
# Predicting heteropolymer phase separation using two-chain contact maps

Supporting data and scripts for:  
**Jessica Jin, Wesley Oliver, Michael A. Webb, William M. Jacobs (2025).**  
*Predicting Heteropolymer Phase Separation Using Two-Chain Contact Maps.*

---

## Data overview

### HP model dataset
- **Sequences**: length-20 heteropolymer sequences with varying hydrophobicity patterns
- **Features**: B_22, Rg, Var(C), Mean(C), S_k (Fourier-derived statistics)
- **Contact maps**: contact maps from two-chain simulations

### IDP dataset
- **`global_dataset.csv`**: 2034 sequences for the global IDP dataset with B_22 and Rg values
- **`idp_challenge_dataset.csv`**: Challenge dataset of 75 sequences with sequence-level features (e.g., charge fraction) and computed phase-separation predictors (B_22, Rg, Var(C), Mean(C), S_k), and contact maps
---

## Simulation and analysis scripts

#### two-chain simulations for HP polymers (`simulation/hp_b2_lammps`)
- Run adaptive biasing force (ABF) simulations to calculate PMFs and compute B_22. The output `out.pmf` from the ABF simulation represents the bias applied during the ABF simulation; the true PMF is computed from this using `get_pmf.py`.

#### single-chain simulations for HP polymers (`simulation/hp_rg_lammps`)
- Compute Rg over time for each sequence to extract the average Rg used as a feature.

#### two-chain simulations for IDP polymers (`simulation/idp_b2_lammps`)
- Example scripts and data files for running two-chain simulations for IDPs to compute B2 and generate contact maps.

#### configuration sampling (`simulation/hp_sample_configurations_lammps`)
- Extract decorrelated configurations within a center-of-mass (COM) distance range for generating two-chain contact maps.

#### direct coexistence simulations (`simulation/hp_direct_coexistence_lammps`)
- Scripts for generating and analyzing slab geometries to classify phase behavior.

#### eos simulations (`simulation/idp_eos_lammps`)
- Example scripts and data files for running EOS simulations at fixed density to classify phase behavior.
---

## data processing and feature extraction (`data_processing`)
- **`build_hp_contact_map.py`** and **`build_idp_contact_map.py`**: Build two-chain contact maps from sampled configurations.  
- **`get_pmf.py`**: Calculate the PMF from `out.pmf` by removing the applied bias.  
- **`rfft.py`**: Perform 2D Fourier decomposition of contact maps and compute explained variance and partial sums of power spectrum.

---

## logistic regression models (`analysis`)
- **`logistic_regression_model.py`**: Example script for training and evaluating logistic regression models. This script uses features from the combined B2-matched dataset to train a split-sum model for predicting phase behavior.

---

## repository structure
- **`contact_maps/`**: pre-computed contact maps for HP and IDP datasets.  
- **`sequences/`**: sequence datasets and associated feature data.
- **`simulation/`**: job scripts and input files for running LAMMPS simulations.  
- **`data_processing/`**: scripts for computing contact maps and extracting Fourier-spectrum features.
- **`analysis/`**: logistic regression model training and evaluation.

---

## reproducing results

1. **Run simulations**: use job scripts in `simulation/` to run single-chain Rg and two-chain ABF simulations.  
2. **Process data**: use `data_processing/` to build contact maps, compute Fourier features, and extract PMFs.  
3. **Train models**: use `analysis/logistic_regression_model.py` to train logistic regression models on extracted features.

---

## citation

If you use this repository, please cite:  
Jessica Jin, Wesley Oliver, Michael A. Webb, William M. Jacobs (2025).  
*Predicting Heteropolymer Phase Separation Using Two-Chain Contact Maps.*
