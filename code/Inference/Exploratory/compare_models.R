# Exploratory: LOO model comparison (linear vs quadratic)
# Run after fit_models.R:
#   Rscript code/Inference/Exploratory/compare_models.R

source("code/project_setup.R")
setup_project()
check_packages(c("brms", "loo"))
library(brms)
library(loo)

if (!file.exists(FIT_LINEAR_PATH) || !file.exists(FIT_QUAD_PATH)) {
  stop(
    "Model files not found. Run fit_models.R first:\n",
    "  Rscript code/Bayseian_Methodology/Exploratory/fit_models.R"
  )
}

fit_linear <- readRDS(FIT_LINEAR_PATH)
fit_quad <- readRDS(FIT_QUAD_PATH)

# --- MODEL COMPARISON ---
loo_linear <- loo(fit_linear)
loo_quad <- loo(fit_quad)
comparison <- loo_compare(loo_linear, loo_quad)

comparison_df <- data.frame(
  model = rownames(comparison),
  comparison,
  row.names = NULL,
  check.names = FALSE
)

dir.create(RESULTS_DIR, recursive = TRUE, showWarnings = FALSE)
brms_loo_path <- file.path(RESULTS_DIR, "brms_loo_comparison.csv")
write.csv(comparison_df, brms_loo_path, row.names = FALSE)

print(comparison_df)
cat("Saved comparison to:", brms_loo_path, "\n")

if (comparison_df$model[1] != "fit_quad") {
  message("Note: LOO prefers the linear model over the quadratic model.")
}
