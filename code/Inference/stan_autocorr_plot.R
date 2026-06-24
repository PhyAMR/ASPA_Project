source("code/Data.R")
library(cmdstanr)
library(bayesplot)
library(ggplot2)

fit_lin  <- readRDS("code/Inference/results/stan_fits/fit_lin.rds")
fit_quad <- readRDS("code/Inference/results/stan_fits/fit_quad.rds")

draws_lin  <- fit_lin$draws(c("alpha", "beta", "sigma"))
draws_quad <- fit_quad$draws(c("alpha", "beta", "gamma", "sigma"))

p_acf_lin  <- mcmc_acf(draws_lin)+ theme_default(base_size = 15)
p_acf_quad <- mcmc_acf(draws_quad)+ theme_default(base_size = 15)

ggsave("code/Inference/results/figures/acf_lin.png",  plot = p_acf_lin,  width = 8, height = 5, dpi = 300)
ggsave("code/Inference/results/figures/acf_quad.png", plot = p_acf_quad, width = 8, height = 5, dpi = 300)

gridExtra::grid.arrange(p_acf_lin, p_acf_quad, ncol = 2)