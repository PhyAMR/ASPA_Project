source("code/Data.R")
source("code/Inference/01_map.R")
library(ggplot2)
library(dplyr)

annual   <- unique(data_imputed[, c("year", "yearly_average")])
annual   <- annual[order(annual$year), ]
t_raw    <- annual$year
t_scaled <- (t_raw - mean(t_raw)) / sd(t_raw)
y        <- annual$yearly_average

# grid of t values for smooth curves
t_grid_scaled <- seq(min(t_scaled), max(t_scaled), length.out = 300)
t_grid_raw    <- t_grid_scaled * sd(t_raw) + mean(t_raw)

df_lin  <- data.frame(year = t_grid_raw,
                       fit  = map_lin$par[1]  + map_lin$par[2]  * t_grid_scaled,
                       model = "Linear")
df_quad <- data.frame(year = t_grid_raw,
                       fit  = map_quad$par[1] + map_quad$par[2] * t_grid_scaled +
                              map_quad$par[3] * t_grid_scaled^2,
                       model = "Quadratic")
df_fits <- bind_rows(df_lin, df_quad)
df_obs  <- data.frame(year = t_raw, y = y)

ggplot() +
  geom_point(data = df_obs, aes(x = year, y = y, color="Data points"), size = 1.2, alpha = 0.7) +
  geom_line(data = df_fits, aes(x = year, y = fit, color = model),
            linewidth = 1.1) +
  scale_color_manual(values = c("Data points" = "grey40", "Linear" = "#E69F00", "Quadratic" = "#0072B2")) +
  labs(
    title = "MAP estimates: linear vs quadratic CO₂ trend",
    x     = "Year",
    y     = expression("CO"[2]*" concentration (ppm)"),
    color = NULL
  ) +
  theme_minimal(base_size = 13)

ggsave("code/Inference/results/figures/map_fits.png", width = 10, height = 6, dpi = 300)