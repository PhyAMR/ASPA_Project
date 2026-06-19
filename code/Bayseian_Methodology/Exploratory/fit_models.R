# Exploratory: Bayesian linear and quadratic model fitting
# Run from project root (after install_pkgs.R if needed):
#   Rscript code/Bayseian_Methodology/Exploratory/fit_models.R

source("code/project_setup.R")
setup_project()
check_packages(c("brms", "dplyr"))
source("code/Data.R")
library(brms)
library(dplyr)

# --- DATA PREPARATION ---
train_data <- data_no_nan %>%
  filter(year <= 2025) %>%
  select(decimal_date, deseasonalized)

head(train_data)
nrow(train_data)

# --- BAYESIAN MODEL FITTING ---
# Default brms priors; update if shared priors are defined elsewhere
mcmc_opts <- list(chains = 4, iter = 2000, warmup = 1000, seed = 42, silent = 2, refresh = 0)

fit_linear <- do.call(brm, c(
  list(formula = deseasonalized ~ decimal_date, data = train_data),
  mcmc_opts
))

fit_quad <- do.call(brm, c(
  list(formula = deseasonalized ~ decimal_date + I(decimal_date^2), data = train_data),
  mcmc_opts
))

# --- SAVE MODELS ---
dir.create(MODEL_DIR, recursive = TRUE, showWarnings = FALSE)
saveRDS(fit_linear, FIT_LINEAR_PATH)
saveRDS(fit_quad, FIT_QUAD_PATH)

cat("Saved models:\n")
cat(" ", FIT_LINEAR_PATH, "\n")
cat(" ", FIT_QUAD_PATH, "\n")
