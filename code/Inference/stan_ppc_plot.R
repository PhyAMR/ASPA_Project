source("code/Data.R")
library(cmdstanr)
library(bayesplot)
library(ggplot2)


annual   <- unique(data_imputed[, c("year", "yearly_average")])
annual   <- annual[order(annual$year), ]
y        <- annual$yearly_average

fit_lin  <- readRDS("code/Inference/results/stan_fits/fit_lin.rds")
fit_quad <- readRDS("code/Inference/results/stan_fits/fit_quad.rds")

y_rep_lin  <- fit_lin$draws("y_rep",  format = "matrix")
y_rep_quad <- fit_quad$draws("y_rep", format = "matrix")

p_ppc_lin <- ppc_dens_overlay(y, y_rep_lin[1:100, ]) +
  scale_x_continuous(limits = c(280, 450), breaks = seq(300, 450, by = 20))+
  ggtitle("Linear model")+
  theme_default(base_size = 15) +
  theme(axis.text.y  = element_text(),
        axis.ticks.y = element_line(),
        axis.line.y  = element_line())

p_ppc_quad <- ppc_dens_overlay(y, y_rep_quad[1:100, ]) +
  scale_x_continuous(limits = c(280, 450), breaks = seq(300, 450, by = 20))+
  ggtitle("Quadratic model")+
  theme_default(base_size = 11) +
  theme(axis.text.y  = element_text(),
        axis.ticks.y = element_line(),
        axis.line.y  = element_line())

ggsave("code/Inference/results/figures/ppc_lin.png",  plot = p_ppc_lin,  width = 8, height = 6, dpi = 300)
ggsave("code/Inference/results/figures/ppc_quad.png", plot = p_ppc_quad, width = 8, height = 6, dpi = 300)

gridExtra::grid.arrange(p_ppc_lin, p_ppc_quad, nrow = 2)