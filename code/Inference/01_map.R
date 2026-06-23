# This is an example of a test file for EDA (Exploratory Data Analysis)
source("code/Data.R")
library(stats)

annual <- unique(data_imputed[, c("year", "yearly_average")])
annual <- annual[order(annual$year), ]

t_raw    <- annual$year
t_scaled <- (t_raw - mean(t_raw)) / sd(t_raw)
y        <- annual$yearly_average

stan_data <- list(N = length(y), t = t_scaled, y = y)

log_posterior_lin <- function(params, t, y) {
  alpha <- params[1]; beta <- params[2]; sigma <- params[3]
  if (sigma <= 0) return(-Inf)
  lp <- dnorm(alpha, 350, 50, log = TRUE) +
        dnorm(beta,    0, 10, log = TRUE) +
        dexp(sigma,    1,     log = TRUE)
  ll <- sum(dnorm(y, alpha + beta * t, sigma, log = TRUE))
  return(lp + ll)
}

log_posterior_quad <- function(params, t, y) {
  alpha <- params[1]; beta <- params[2]
  gamma <- params[3]; sigma <- params[4]
  if (sigma <= 0) return(-Inf)
  lp <- dnorm(alpha, 350, 50, log = TRUE) +
        dnorm(beta,    0, 10, log = TRUE) +
        dnorm(gamma,   0,  5, log = TRUE) +
        dexp(sigma,    1,     log = TRUE)
  ll <- sum(dnorm(y, alpha + beta * t + gamma * t^2, sigma, log = TRUE))
  return(lp + ll)
}

map_lin <- optim(
  par     = c(350, 16, 2),
  fn      = log_posterior_lin,
  t       = t_scaled, y = y,
  control = list(fnscale = -1),
  method  = "BFGS",
  hessian = TRUE
)

map_quad <- optim(
  par     = c(350, 2, 0, 1),
  fn      = log_posterior_quad,
  t       = t_scaled, y = y,
  control = list(fnscale = -1),
  method  = "BFGS",
  hessian = TRUE
)

map_lin_df <- data.frame(
  parameter = c("alpha", "beta", "sigma"),
  map       = c(map_lin$par[1], map_lin$par[2], map_lin$par[3]),
  converged = map_lin$convergence == 0
)

map_quad_df <- data.frame(
  parameter = c("alpha", "beta", "gamma", "sigma"),
  map       = c(map_quad$par[1], map_quad$par[2], map_quad$par[3], map_quad$par[4]),
  converged = map_quad$convergence == 0
)

#cat("MAP: Linear model \n")
#cat("alpha:", map_lin$par[1],  "\n")
#cat("beta: ", map_lin$par[2],  "\n")
#cat("sigma:", map_lin$par[3],  "\n")
#cat("Converged:", map_lin$convergence == 0, "\n\n")
#
#cat("MAP: Quadratic model \n")
#cat("alpha:", map_quad$par[1], "\n")
#cat("beta: ", map_quad$par[2], "\n")
#cat("gamma:", map_quad$par[3], "\n")
#cat("sigma:", map_quad$par[4], "\n")
#cat("Converged:", map_quad$convergence == 0, "\n")
