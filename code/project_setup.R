# Shared project setup: working directory, package checks, artifact paths

MODEL_DIR <- "models"
RESULTS_DIR <- "results"
FIT_LINEAR_PATH <- file.path(MODEL_DIR, "fit_linear.rds")
FIT_QUAD_PATH <- file.path(MODEL_DIR, "fit_quad.rds")
STAN_FIT_LINEAR_PATH <- file.path("code", "Inference", "results", "stan_fits", "fit_lin.rds")
STAN_FIT_QUAD_PATH <- file.path("code", "Inference", "results", "stan_fits", "fit_quad.rds")
STAN_LOO_CSV_PATH <- file.path(RESULTS_DIR, "stan_model_comparison.csv")
FORECAST_PLOT_PATH <- file.path(RESULTS_DIR, "forecast_plot.png")

find_project_root <- function() {
  if (file.exists("data/co2_data.txt") && file.exists("code/Data.R")) {
    return(normalizePath("."))
  }
  script_file <- sub("^--file=", "", grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE))
  if (length(script_file) == 1) {
    dir <- normalizePath(dirname(script_file))
    for (i in 1:6) {
      if (file.exists(file.path(dir, "data/co2_data.txt")) &&
          file.exists(file.path(dir, "code/Data.R"))) {
        return(dir)
      }
      parent <- normalizePath(file.path(dir, ".."))
      if (parent == dir) break
      dir <- parent
    }
  }
  stop(
    "Could not find ASPA_Project root.\n",
    "Run from the project folder, e.g. in WSL:\n",
    "  cd '/mnt/c/Users/carlo/Documents/POD_Masters/Statistics for PoD/Final_Project/ASPA_Project'\n",
    "  Rscript code/Prediction/prediction.R"
  )
}

setup_project <- function() {
  setwd(find_project_root())
}

check_packages <- function(pkgs) {
  missing_pkgs <- pkgs[!vapply(pkgs, requireNamespace, quietly = TRUE, FUN.VALUE = logical(1))]
  if (length(missing_pkgs) > 0) {
    stop(
      "Missing R packages: ", paste(missing_pkgs, collapse = ", "), "\n\n",
      "Install once with:\n",
      "  Rscript code/install_pkgs.R"
    )
  }
}
