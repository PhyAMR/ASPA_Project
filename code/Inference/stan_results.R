source("code/Data.R")
library(cmdstanr)
library(posterior)

fit_lin  <- readRDS("code/Inference/results/stan_fits/fit_lin.rds")
fit_quad <- readRDS("code/Inference/results/stan_fits/fit_quad.rds")

stan_lin  <- as.data.frame(fit_lin$summary(c("alpha", "beta", "sigma")))
stan_quad <- as.data.frame(fit_quad$summary(c("alpha", "beta", "gamma", "sigma")))

# Tables rendered separately in main.qmd
