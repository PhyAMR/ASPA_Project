# Parameters' inference:
We are considering now 2 different models that could explain our dataset. The first model considers the data to be sampled from a linear function with the addition of noise:
 $$y_t = \alpha + \beta t + \epsilon_t$$

The second model considers the data to be sampled in a similar way, but with the addition of a quadratic term (that we can consider as an acceleration):
 $$y_t = \alpha + \beta t + \gamma t^2 + \epsilon_t$$

To infer an estimation of our parameters we have tried different models seen in class: MAP estimator, credible intervals and STAN method. Each one of the methods are presented in the following paragraphs.
In this studying we have used the data averaged over one year. Moreover we have rescaled time:
 $$t_{scaled} = \frac{t-\bar{t}}{s_t}$$

## Inference of parameters via MAP:

For the MAP estimate we have maximized the following joint posteriors:

$$log(p_{lin}(\theta | y)) = log(p(\alpha)) + log(p(\beta))+ log(p(\sigma)) + log(p_{lin}(y|\alpha, \beta, \sigma))$$

$$log(p_{quad}(\theta | y)) = log(p(\alpha)) + log(p(\beta))+ log(p(\gamma)) + log(p(\sigma)) + log(p_{quad}(y|\alpha, \beta, \gamma, \sigma))$$

We are considering the following priors:
$$\alpha \propto N(350, 50^2)$$
$$\beta \propto N(0, 10^2)$$
$$\gamma \propto N(0,5^2)$$
$$\sigma \propto Exp(1)$$

and the likelihoods are in the following form:
$$log(p_{lin}(y|\alpha, \beta, \sigma)) = \sum_{t}log(N(y_{t}|\alpha + \beta*t, \sigma^2))$$

$$log(p_{quad}(y|\alpha, \beta, \gamma, \sigma)) = \sum_{t}log(N(y_{t}|\alpha + \beta*t + \gamma * t^2, \sigma^2))$$

In this way we find the point estimation given by:
$$\hat{theta_{lin}} = \arg\max_\theta \left[ log(p_{lin}(y|\alpha, \beta, \sigma)) \right]$$

$$\hat{theta_{quad}} = \arg\max_\theta \left[ log(p_{quad}(y|\alpha, \beta, \gamma, \sigma)) \right]$$

Where $$\hat{theta_{lin}}=(\hat{\alpha_{lin}}, \hat{\beta_{lin}}, \hat{\sigma_{lin}})$$ and $$\hat{theta_{quad}} = (\hat{\alpha_{quad}}, \hat{\beta_{quad}}, \hat{\gamma_{quad}}, \hat{\sigma_{quad}})$$.
The maximization process has been done with the method "BFGS" and gave the following results:

(DATAFRAME: code/Inference/01_map.R script, dataframes: map_lin_df, map_quad_df)
MAP: Linear model 
alpha: 361.5762 
beta:  33.45604 
sigma: 4.712262 
Converged: TRUE 

MAP: Quadratic model 
alpha: 356.1989 
beta:  33.56266 
gamma: 5.458365 
sigma: 0.7412628 
Converged: TRUE 

(PLOT: code/Inference/map_comp_plot.R, image saved in: code/Inference/results/figures/map_comparison.png)
(PLOT DESCRIPTION: This plot shows the difference in the parameters that are common to the 2 models. This is done to appreciate how the addition of a quadratic term impacts in the parameters' inference.)

From the histogram above we notice a huge drop in the parameter $\sigma$ between the 2 models. This suggests that the quadratic model has the capacity to absorb a large part of the data's deviations rather than the linear model.
This can be appreciate in the following plot too. Here the quadratic model is way more representative of the data with respect to the linear one. 

(PLOT: code/Inference/map_plot.R, image saved in: code/Inference/results/figures/map_fits.png)
(PLOT DESCRIPTION: The plot shows the yearly averaged concetration's data versus years. In orange we see the linear fit considering the $$\hat{theta_{lin}}$$ calculated. In blue we see the quadratic fit considering the $$\hat{theta_{quad}}$$ calculated. It can be noticed that the quadratic fit is able to follow the data in a more efficient way with respect to the linear fit.)

In the context of Bayesian inference, MAP estimators provide only a point estimation dependent just on the local behaviour of the posterior near its maximum, regardless about spread, skewness or multimodality.For this reason we should consider methods that consider the full joint posterior distribution. With this purpose we present now the results given by STAN.

## Inference of parameters via STAN:
For both models we have run 4 chains using STAN. The results are the following:

(DATAFRAME: code/Inference/03_stan.R, dataframes: stan_lin, stan_quad)

=== Stan: Linear model ===
# A tibble: 3 × 10
  variable   mean median    sd   mad     q5    q95  rhat ess_bulk ess_tail
  <chr>     <dbl>  <dbl> <dbl> <dbl>  <dbl>  <dbl> <dbl>    <dbl>    <dbl>
1 alpha    362.   362.   0.580 0.575 361.   363.    1.00    6914.    5774.
2 beta      33.4   33.4  0.585 0.580  32.5   34.4   1.00    7215.    5627.
3 sigma      4.86   4.83 0.412 0.412   4.23   5.58  1.00    6510.    5597.

=== Stan: Quadratic model ===
# A tibble: 4 × 10
  variable    mean  median     sd    mad      q5     q95  rhat ess_bulk ess_tail
  <chr>      <dbl>   <dbl>  <dbl>  <dbl>   <dbl>   <dbl> <dbl>    <dbl>    <dbl>
1 alpha    356.    356.    0.140  0.137  356.    356.    1.00     4984.    5149.
2 beta      33.6    33.6   0.0945 0.0923  33.4    33.7   1.00     6814.    5014.
3 gamma      5.46    5.46  0.106  0.105    5.29    5.63  1.00     5000.    5141.
4 sigma      0.771   0.767 0.0670 0.0668   0.670   0.887 1.000    7052.    6010.

For both models the autocorrelation should be low, as can be notice from the large ESS values, and all the 4 chains are converging to the same stationary distribution, indeed $$\hat{R}$$ is always equal to 1. 
We can visualize this 2 characteristics using the following plots:

(PLOT: code/Inference/stan_autocorr_plot.R, images saved in: code/Inference/results/figures/acf_lin.png, code/Inference/results/figures/acf_quad.png)
(PLOT DESCRIPTION: The plots show the autocorrelation behaviours for all parameters in all 4 chains.)

(PLOT: code/Inference/stan_trace_plot.R, images saved in: code/Inference/results/figures/trace_lin.png, code/Inference/results/figures/trace_quad.png)
(PLOT DESCRIPTION: The plots show the traces done by the 4 chains for every parameter. Notice that they are completely overlapped, as we expected from $$\hat{R}= 1$$.)

Using the KDE plots, comparing the KDE function of the real data with the ones generated by STAN, we can note further how the quadratic model is more representative than the linear one:

(PLOT: code/Inference/stan_ppc_plot.R, images saved in: code/Inference/results/figures/ppc_lin.png, code/Inference/results/figures/ppc_quad.png)
(PLOT DESCRIPTION: The plot shows the KDE of our dataset (dark blue one) compared to the KDE of 100 synthetich datasets (light blue ones) generated by STAN using the sampled parameters. It can be noticed how the quadratic model is reproducing the real KDE function in a way more accurate mode.)

Let's visualize now the two models' predictions against the observed data:
(PLOT: code/Model_comparison/plot.R, image saved in code/Model_comparison/results/figures/model_comparison_ppc.png)
(PLOT DESCRIPTION: The plot shows the yearly averaged concetration's data versus years. In orange we see the linear fit considering the parameters calculated during STAN procedure and its 95% uncertainty band. In blue we see the quadratic fit considering the parameters calculated during STAN procedure and its 95% uncertainty band.)

# Model comparison:
In the parameters' inference part we had already seen that the quadratic model is a better approximation of the data. Now we want to underline this convenience using model comparison. We used two methods: the Bayesian factor and the LOO method.

## Model comparison with Bayesian factor:
The Bayes' factor is the ratio between the marginal likelihood of the 2 models:
 $$BF = \frac{p(y \mid M_1)}{p(y \mid M_0)}$$
where: $$p(y \mid M_k) = \int {p(y \mid \theta, M_k) p(\theta \mid M_k) d\theta}.
Since this formula usually brings to an intractable integral we have used the Laplace's approximation that expands the log-posterior around the MAP estimate $$\bar{\theta}$$. This leads to:

 $$log p(y \mid M_k) \propto log p(\bar{\theta} \mid y) + \frac{d}{2} log(2 \pi) - \frac{log det(H)}{2}$$

Where H is the negative of the log-posterior's Hessian.

The Bayes' factor calculated in this way brings to the following results:

(RUN SCRIPT: code/Model_comparison/model_comp.R)

Since $$log_{10} BF = 53.66 >> 1$$, we can state that the quadratic model is definitely more appropriate to represent our data.

## Model comparison with LOO method:
The goal of LOO method is to calculate how well our model predicts new and unseen data. The aim is to calculate ELPD (expected log predictive density):
 $$ elpd = \sum_{i=1}^n \int log p(y_i* \mid y_{-i}) p_t(y_i*) dy_i* $$
where the terms $$p(y_i* \mid y_{-i})$$ are the log posterior predictive density for $$y_i*$$ when the model was fitted without it.
Then it simply compare the ELPD values between the 2 models:
$$\Delta \hat{ELPD} = \hat{ELPD}_{lin} - \hat{ELPD}_{quad}$$.

(RUN SCRIPT: model_comp_loo.R)

The LOO comparison yields $$\hat{\Delta_{ELPD}} = -128.9$$ and $$\hat{\Delta_{SE}} = 7.9$$, corresponding to a ratio of $$\frac{\mid \hat{\Delta_{ELPD}} \mid}{SE} \approx 16$$. This confirms decisively that the quadratic model has much greater predictive ability compared to the linear one.


