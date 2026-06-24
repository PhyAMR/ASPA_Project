source("code/Data.R")
library(cmdstanr)
library(bayesplot)
library(ggplot2)

fit_lin  <- readRDS("code/Inference/results/stan_fits/fit_lin.rds")
fit_quad <- readRDS("code/Inference/results/stan_fits/fit_quad.rds")

draws_lin  <- fit_lin$draws(c("alpha", "beta", "sigma"))
draws_quad <- fit_quad$draws(c("alpha", "beta", "gamma", "sigma"))

p_trace_lin  <- mcmc_trace(draws_lin)+ theme_default(base_size = 15)
p_trace_quad <- mcmc_trace(draws_quad)+ theme_default(base_size = 15)

ggsave("code/Inference/results/figures/trace_lin.png",  plot = p_trace_lin,  width = 8, height = 5, dpi = 300)
ggsave("code/Inference/results/figures/trace_quad.png", plot = p_trace_quad, width = 8, height = 5, dpi = 300)

gridExtra::grid.arrange(p_trace_lin, p_trace_quad, nrow = 2)