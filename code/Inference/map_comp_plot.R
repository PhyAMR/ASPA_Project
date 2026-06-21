source("code/Inference/01_map.R")
library(ggplot2)
library(dplyr)

# MAP values for common parameters
map_comparison <- data.frame(
  parameter = rep(c("alpha", "beta", "sigma"), 2),
  model     = rep(c("Linear", "Quadratic"), each = 3),
  value     = c(
    map_lin$par[1],  map_lin$par[2],  map_lin$par[3],   # linear
    map_quad$par[1], map_quad$par[2], map_quad$par[4]    # quadratic (sigma is par[4])
  )
)

ggplot(map_comparison, aes(x = model, y = value, fill = model)) +
  geom_col(width = 0.5) +
  geom_text(aes(label = round(value, 2)),
            vjust = -0.5, size = 3.5) +
  facet_wrap(~ parameter, scales = "free_y",
             labeller = labeller(parameter = c(
               alpha = expression(alpha),
               beta  = expression(beta),
               sigma = expression(sigma)
             ))) +
  scale_fill_manual(values = c("Linear" = "#E69F00", "Quadratic" = "#0072B2")) +
  labs(
    title = "MAP estimates: common parameters across models",
    x     = NULL,
    y     = "MAP value",
    fill  = "Model"
  ) +
  theme_minimal(base_size = 13) +
  theme(strip.text = element_text(face = "bold"),
        legend.position = "none")

ggsave("code/Inference/results/figures/map_comparison.png", width = 9, height = 5, dpi = 300)