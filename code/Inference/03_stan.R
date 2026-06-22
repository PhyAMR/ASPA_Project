source("code/Data.R")
library(cmdstanr)
library(posterior)

annual   <- unique(data_imputed[, c("year", "yearly_average")])
annual   <- annual[order(annual$year), ]
t_raw    <- annual$year
t_scaled <- (t_raw - mean(t_raw)) / sd(t_raw)
y        <- annual$yearly_average

stan_data <- list(N = length(y), t = t_scaled, y = y)

mod_lin  <- cmdstan_model("code/Inference/linear.stan")
mod_quad <- cmdstan_model("code/Inference/quadratic.stan")

fit_lin <- mod_lin$sample(
  data         = stan_data,
  chains       = 4,
  iter_warmup  = 1000,
  iter_sampling = 2000,
  seed         = 42
)

fit_quad <- mod_quad$sample(
  data          = stan_data,
  chains        = 4,
  iter_warmup   = 1000,
  iter_sampling = 2000,
  seed          = 42
)

stan_lin <- as.data.frame(fit_lin$summary(c("alpha", "beta", "sigma")))
stan_quad <- as.data.frame(fit_quad$summary(c("alpha", "beta", "gamma", "sigma")))

cat("Stan: Linear model \n")
print(fit_lin$summary(c("alpha", "beta", "sigma")))

cat("\nStan: Quadratic model \n")
print(fit_quad$summary(c("alpha", "beta", "gamma", "sigma")))

cat("\nDiagnostics: Linear \n")
fit_lin$cmdstan_diagnose()

cat("\nDiagnostics: Quadratic\n")
fit_quad$cmdstan_diagnose()

dir.create("code/Inference/results/stan_fits", recursive = TRUE, showWarnings = FALSE)
fit_lin$save_object("code/Inference/results/stan_fits/fit_lin.rds")
fit_quad$save_object("code/Inference/results/stan_fits/fit_quad.rds")
