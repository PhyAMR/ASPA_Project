# Predictive Forecasting: Bayesian quadratic CO2 trend projection (2026-2036)
# Run after fit_models.R (and optionally compare_models.R):
#   Rscript code/Prediction/prediction.R
# First-time setup:
#   Rscript code/install_pkgs.R

source("code/project_setup.R")
setup_project()
check_packages(c("brms", "ggplot2", "dplyr"))
source("code/Data.R")
library(brms)
library(ggplot2)
library(dplyr)

if (!file.exists(FIT_QUAD_PATH)) {
  stop(
    "Quadratic model not found. Run fit_models.R first:\n",
    "  Rscript code/Bayseian_Methodology/Exploratory/fit_models.R"
  )
}

# --- DATA PREPARATION ---
train_data <- data_no_nan %>%
  filter(year <= 2025) %>%
  select(decimal_date, deseasonalized)

fit_quad <- readRDS(FIT_QUAD_PATH)

# --- POSTERIOR EXTRACTION ---
post_draws <- as_draws_df(fit_quad)

b0 <- post_draws$b_Intercept
b1 <- post_draws$b_decimal_date
b2_col <- setdiff(
  grep("^b_", names(post_draws), value = TRUE),
  c("b_Intercept", "b_decimal_date", "b_sigma")
)
if (length(b2_col) != 1) {
  stop("Could not identify quadratic coefficient column in posterior draws.")
}
b2 <- post_draws[[b2_col]]

# --- ANNUAL PROJECTIONS (2026-2036) ---
forecast_years <- 2026:2036
forecast_dates <- forecast_years + 0.5

pred_matrix <- sapply(forecast_dates, function(x) {
  b0 + b1 * x + b2 * x^2
})

projections <- data.frame(
  year = forecast_years,
  decimal_date = forecast_dates,
  pred_mean = colMeans(pred_matrix),
  lower_95 = apply(pred_matrix, 2, quantile, probs = 0.025),
  upper_95 = apply(pred_matrix, 2, quantile, probs = 0.975)
)

print(projections)

hist_grid <- seq(min(train_data$decimal_date), max(train_data$decimal_date), length.out = 200)
hist_matrix <- sapply(hist_grid, function(x) {
  b0 + b1 * x + b2 * x^2
})

hist_fit <- data.frame(
  decimal_date = hist_grid,
  fit_mean = colMeans(hist_matrix),
  lower_95 = apply(hist_matrix, 2, quantile, probs = 0.025),
  upper_95 = apply(hist_matrix, 2, quantile, probs = 0.975)
)

# --- VISUALIZATION ---
forecast_plot <- ggplot() +
  geom_point(
    data = train_data,
    aes(x = decimal_date, y = deseasonalized, color = "Deseasonalized"),
    size = 0.5
  ) +
  geom_ribbon(
    data = hist_fit,
    aes(x = decimal_date, ymin = lower_95, ymax = upper_95),
    fill = "green4", alpha = 0.15, inherit.aes = FALSE
  ) +
  geom_line(
    data = hist_fit,
    aes(x = decimal_date, y = fit_mean, color = "Quadratic Fit"),
    linewidth = 0.8
  ) +
  geom_vline(xintercept = 2025.5, linetype = "dotted", color = "gray40", linewidth = 0.5) +
  geom_ribbon(
    data = projections,
    aes(x = decimal_date, ymin = lower_95, ymax = upper_95),
    fill = "green4", alpha = 0.25, inherit.aes = FALSE
  ) +
  geom_line(
    data = projections,
    aes(x = decimal_date, y = pred_mean, color = "Projection (2026-2036)"),
    linewidth = 1, linetype = "dashed"
  ) +
  scale_color_manual(
    name = "Data & Models",
    values = c(
      "Deseasonalized"           = "firebrick",
      "Quadratic Fit"            = "green4",
      "Projection (2026-2036)"   = "green4"
    )
  ) +
  coord_cartesian(ylim = c(310, 450)) +
  scale_x_continuous(breaks = seq(1960, 2040, by = 10)) +
  theme_minimal() +
  labs(
    title = expression("Mauna Loa CO"[2]*" Bayesian Quadratic Forecast"),
    subtitle = "95% credible bands on trend; training data through 2025",
    x = "Year",
    y = expression(paste("Average CO" [2], " Concentration (ppm) (", pm, " ", sigma, ")"))
  )

dir.create(RESULTS_DIR, recursive = TRUE, showWarnings = FALSE)
ggsave(FORECAST_PLOT_PATH, forecast_plot, width = 10, height = 6)
cat("Saved plot to:", FORECAST_PLOT_PATH, "\n")

forecast_plot
