# Predictive Forecasting: Stan quadratic CO2 trend projection (2026-2036)
# Run after colleague's Stan fits:
#   Rscript code/Inference/03_stan.R
#   Rscript code/Prediction/prediction.R

source("code/project_setup.R")
setup_project()
check_packages(c("cmdstanr", "loo", "ggplot2", "dplyr"))
source("code/Data.R")
library(cmdstanr)
library(loo)
library(ggplot2)
library(dplyr)

if (!file.exists(STAN_FIT_LINEAR_PATH) || !file.exists(STAN_FIT_QUAD_PATH)) {
  stop(
    "Stan model fits not found. Run 03_stan.R first:\n",
    "  Rscript code/Inference/03_stan.R"
  )
}

fit_lin <- readRDS(STAN_FIT_LINEAR_PATH)
fit_quad <- readRDS(STAN_FIT_QUAD_PATH)

# --- MODEL COMPARISON (LOO) ---
# loo_compare(loo_lin, loo_quad) names rows model1 (linear) and model2 (quadratic)
model_labels <- c(model1 = "Linear", model2 = "Quadratic")

loo_lin <- fit_lin$loo()
loo_quad <- fit_quad$loo()
comparison_mat <- loo_compare(loo_lin, loo_quad)

comparison_df <- data.frame(
  section = "models",
  model = model_labels[rownames(comparison_mat)],
  elpd_loo = round(comparison_mat[, "elpd_loo"], 2),
  se_elpd_loo = round(comparison_mat[, "se_elpd_loo"], 2),
  looic = round(comparison_mat[, "looic"], 2),
  se_looic = round(comparison_mat[, "se_looic"], 2),
  p_loo = round(comparison_mat[, "p_loo"], 2),
  elpd_diff_vs_best = round(comparison_mat[, "elpd_diff"], 2),
  se_elpd_diff = round(comparison_mat[, "se_diff"], 2),
  rank = seq_len(nrow(comparison_mat)),
  preferred = comparison_mat[, "elpd_diff"] == 0,
  quote_text = NA_character_,
  stringsAsFactors = FALSE
)

best_model <- comparison_df$model[1]
runner_up <- comparison_df$model[2]
elpd_diff <- abs(comparison_df$elpd_diff_vs_best[2])
se_diff <- comparison_df$se_elpd_diff[2]

quote_sentence <- sprintf(
  "The %s model is preferred by LOO-CV (delta ELPD = %.1f +/- %.1f vs %s).",
  tolower(best_model), elpd_diff, se_diff, tolower(runner_up)
)

summary_rows <- data.frame(
  section = rep("summary", 4),
  model = c("preferred_model", "elpd_diff", "data_source", "comparison_method"),
  elpd_loo = NA_real_,
  se_elpd_loo = NA_real_,
  looic = NA_real_,
  se_looic = NA_real_,
  p_loo = NA_real_,
  elpd_diff_vs_best = c(NA, elpd_diff, NA, NA),
  se_elpd_diff = c(NA, se_diff, NA, NA),
  rank = NA_integer_,
  preferred = NA,
  quote_text = c(
    quote_sentence,
    sprintf("%.2f +/- %.2f", elpd_diff, se_diff),
    "data_imputed yearly_average",
    "LOO-CV (Stan)"
  ),
  stringsAsFactors = FALSE
)

comparison_out <- bind_rows(comparison_df, summary_rows)

dir.create(RESULTS_DIR, recursive = TRUE, showWarnings = FALSE)
write.csv(comparison_out, STAN_LOO_CSV_PATH, row.names = FALSE)
cat("Saved model comparison to:", STAN_LOO_CSV_PATH, "\n")
print(comparison_df)

# --- DATA PREPARATION (match 03_stan.R) ---
annual <- unique(data_imputed[, c("year", "yearly_average")])
annual <- annual[order(annual$year), ]

t_mean <- mean(annual$year)
t_sd <- sd(annual$year)
scale_year <- function(y) (y - t_mean) / t_sd

train_data <- annual %>% filter(year <= 2025)

# --- POSTERIOR EXTRACTION ---
draws <- fit_quad$draws(c("alpha", "beta", "gamma"), format = "matrix")
alpha <- draws[, "alpha"]
beta <- draws[, "beta"]
gamma <- draws[, "gamma"]

# --- ANNUAL PROJECTIONS (2026-2036) ---
forecast_years <- 2026:2036

pred_matrix <- sapply(forecast_years, function(y) {
  t <- scale_year(y)
  alpha + beta * t + gamma * t^2
})

projections <- data.frame(
  year = forecast_years,
  pred_mean = colMeans(pred_matrix),
  lower_95 = apply(pred_matrix, 2, quantile, probs = 0.025),
  upper_95 = apply(pred_matrix, 2, quantile, probs = 0.975)
)

print(projections)

hist_years <- seq(min(train_data$year), max(train_data$year), length.out = 200)
hist_matrix <- sapply(hist_years, function(y) {
  t <- scale_year(y)
  alpha + beta * t + gamma * t^2
})

hist_fit <- data.frame(
  year = hist_years,
  fit_mean = colMeans(hist_matrix),
  lower_95 = apply(hist_matrix, 2, quantile, probs = 0.025),
  upper_95 = apply(hist_matrix, 2, quantile, probs = 0.975)
)

# --- VISUALIZATION ---
forecast_plot <- ggplot() +
  geom_point(
    data = train_data,
    aes(x = year, y = yearly_average, color = "Yearly average"),
    size = 1
  ) +
  geom_ribbon(
    data = hist_fit,
    aes(x = year, ymin = lower_95, ymax = upper_95),
    fill = "green4", alpha = 0.15, inherit.aes = FALSE
  ) +
  geom_line(
    data = hist_fit,
    aes(x = year, y = fit_mean, color = "Quadratic Fit"),
    linewidth = 0.8
  ) +
  geom_vline(xintercept = 2025, linetype = "dotted", color = "gray40", linewidth = 0.5) +
  geom_ribbon(
    data = projections,
    aes(x = year, ymin = lower_95, ymax = upper_95),
    fill = "green4", alpha = 0.25, inherit.aes = FALSE
  ) +
  geom_line(
    data = projections,
    aes(x = year, y = pred_mean, color = "Projection (2026-2036)"),
    linewidth = 1, linetype = "dashed"
  ) +
  scale_color_manual(
    name = "Data & Models",
    values = c(
      "Yearly average"           = "firebrick",
      "Quadratic Fit"            = "green4",
      "Projection (2026-2036)"   = "green4"
    )
  ) +
  coord_cartesian(ylim = c(310, 450)) +
  scale_x_continuous(breaks = seq(1960, 2040, by = 10)) +
  theme_minimal() +
  labs(
    title = expression("Mauna Loa CO"[2]*" Stan Quadratic Forecast"),
    subtitle = "95% credible bands; yearly averages from imputed data through 2025",
    x = "Year",
    y = expression(paste("Average CO"[2], " concentration (ppm)"))
  )

ggsave(FORECAST_PLOT_PATH, forecast_plot, width = 10, height = 6, dpi = 300)
cat("Saved plot to:", FORECAST_PLOT_PATH, "\n")

forecast_plot
