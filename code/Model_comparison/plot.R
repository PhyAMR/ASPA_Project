source("code/Data.R")
library(cmdstanr)
library(ggplot2)
library(dplyr)

annual   <- unique(data_imputed[, c("year", "yearly_average")])
annual   <- annual[order(annual$year), ]
t_raw    <- annual$year
t_scaled <- (t_raw - mean(t_raw)) / sd(t_raw)
y        <- annual$yearly_average

fit_lin  <- readRDS("code/Inference/results/stan_fits/fit_lin.rds")
fit_quad <- readRDS("code/Inference/results/stan_fits/fit_quad.rds")

y_rep_lin  <- fit_lin$draws("y_rep",  format = "matrix")
y_rep_quad <- fit_quad$draws("y_rep", format = "matrix")

# posterior mean and 95% credible band for each time point
summarise_yrep <- function(y_rep, years) {
  data.frame(
    year  = years,
    mean  = colMeans(y_rep),
    lower = apply(y_rep, 2, quantile, 0.025),
    upper = apply(y_rep, 2, quantile, 0.975)
  )
}

pred_lin  <- summarise_yrep(y_rep_lin,  t_raw)
pred_quad <- summarise_yrep(y_rep_quad, t_raw)

pred_lin$model  <- "Linear"
pred_quad$model <- "Quadratic"
pred_all <- bind_rows(pred_lin, pred_quad)

obs <- data.frame(year = t_raw, y = y)

ggplot() +
  geom_point(data = obs, aes(x = year, y = y),
             color = "black", size = 1, alpha = 0.6) +
  geom_ribbon(data = pred_all,
              aes(x = year, ymin = lower, ymax = upper, fill = model),
              alpha = 0.25) +
  geom_line(data = pred_all,
            aes(x = year, y = mean, color = model), linewidth = 1) +
  scale_color_manual(values = c("Linear" = "#E69F00", "Quadratic" = "#0072B2")) +
  scale_fill_manual( values = c("Linear" = "#E69F00", "Quadratic" = "#0072B2")) +
  labs(
    title   = expression("Posterior predictive check: linear vs quadratic CO"[2]*" trend"),
    x       = "Year",
    y       = expression("CO"[2]*" concentration (ppm)"),
    color   = "Model",
    fill    = "Model"
  ) +
  theme_minimal(base_size = 10)

ggsave("code/Model_comparison/results/figures/model_comparison_ppc.png",
       width = 10, height = 6, dpi = 300)