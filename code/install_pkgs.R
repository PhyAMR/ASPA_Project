options(repos = c(CRAN = "https://cloud.r-project.org"))
user_lib <- Sys.getenv("R_LIBS_USER")
if (!nzchar(user_lib)) {
  user_lib <- file.path(Sys.getenv("HOME"), "R", paste0(R.version$platform, "-library"), R.version$major)
}
dir.create(user_lib, recursive = TRUE, showWarnings = FALSE)
.libPaths(c(user_lib, .libPaths()))

# Remove stale lock dirs left by interrupted installs (common with long rstan/brms builds)
lock_dirs <- list.files(user_lib, pattern = "^00LOCK-", full.names = TRUE)
if (length(lock_dirs) > 0) {
  cat("Removing stale install locks:", paste(basename(lock_dirs), collapse = ", "), "\n")
  unlink(lock_dirs, recursive = TRUE)
}

needed <- c("ggplot2", "dplyr", "loo", "brms")
missing <- needed[!needed %in% rownames(installed.packages())]
if (length(missing) > 0) {
  cat("Installing into:", user_lib, "\n")
  cat("Packages:", paste(missing, collapse = ", "), "\n")
  install.packages(missing, lib = user_lib)
} else {
  cat("All packages already installed.\n")
}
