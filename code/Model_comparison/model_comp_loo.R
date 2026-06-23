source("code/Data.R")
library(cmdstanr)
library(loo)

fit_lin  <- readRDS("code/Inference/results/stan_fits/fit_lin.rds")
fit_quad <- readRDS("code/Inference/results/stan_fits/fit_quad.rds")

loo_lin  <- fit_lin$loo()
loo_quad <- fit_quad$loo()

#cat("LOO: Linear model\n")
#print(loo_lin)
#
#cat("\nLOO: Quadratic model\n")
#print(loo_quad)
#
#cat("\nLOO comparison (best model listed first):\n")
#print(loo_compare(loo_lin, loo_quad))

# Extract LOO comparison results
loo_comp <- loo_compare(loo_lin, loo_quad)
elpd_diff_val <- loo_comp[2, 1]  # Difference in ELPD
elpd_se_val <- loo_comp[2, 2]    # SE of difference
