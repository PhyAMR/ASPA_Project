source("code/Data.R")
source("code/Inference/01_map.R")

laplace_log_ml <- function(map_result) {
  log_post_at_map <- map_result$value
  H               <- -map_result$hessian
  d               <- length(map_result$par)
  log_ml          <- log_post_at_map + (d / 2) * log(2 * pi) - 0.5 * log(det(H))
  return(log_ml)
}

log_ml_lin  <- laplace_log_ml(map_lin)
log_ml_quad <- laplace_log_ml(map_quad)

log_BF   <- log_ml_quad - log_ml_lin
log10_BF <- log_BF / log(10)

#cat("Log marginal likelihood (linear):    ", log_ml_lin,  "\n")
#cat("Log marginal likelihood (quadratic): ", log_ml_quad, "\n")
#cat("Log10 BF (quad vs lin):              ", log10_BF,    "\n")