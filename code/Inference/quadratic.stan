data {
  int<lower=0> N;
  vector[N] t;
  vector[N] y;
}
parameters {
  real alpha;
  real beta;
  real gamma;
  real<lower=0> sigma;
}
model {
  // Priors
  alpha ~ normal(350, 50);
  beta  ~ normal(0, 10);
  gamma ~ normal(0, 5);
  sigma ~ exponential(1);
  // Likelihood
  y ~ normal(alpha + beta * t + gamma * t .* t, sigma);
}
generated quantities {
  vector[N] y_rep;
  vector[N] log_lik;
  for (i in 1:N) {
    y_rep[i]   = normal_rng(alpha + beta * t[i] + gamma * t[i]^2, sigma);
    log_lik[i] = normal_lpdf(y[i] | alpha + beta * t[i] + gamma * t[i]^2, sigma);
  }
}