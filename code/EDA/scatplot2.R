source("code/Data.R")
library(ggplot2)

ggplot(data_imputed, aes(x = decimal_date)) +
  # 1. Error bars for monthly average    
  
  # 2. Monthly Average Points
  geom_point(aes(y = deseasonalized, color = "Deseasonalized"), size = 0.5) +
  
  
  # 4. Trend lines mapped to custom colors in aes()
  geom_smooth(aes(y = deseasonalized, color = "Linear Fit"), method = "lm", formula = y ~ x, se = FALSE) +
  geom_smooth(aes(y = deseasonalized, color = "Quadratic Fit"), method = "lm", formula = y ~ x + I(x^2), se = FALSE) +
  
  # 5. EQUATION LABELS: Manually placed in empty areas of the graph
  # Adjust the 'x' and 'y' coordinates to fit your data's exact range perfectly
  annotate("text", x = 1970, y = 390, label = "Linear: y == beta[0] + beta[1]*x", 
           color = "blue", parse = TRUE, hjust = 0, size = 4) +
  annotate("text", x = 1970, y = 380, label = "Quadratic: y == beta[0] + beta[1]*x + beta[2]*x^2", 
           color = "green4", parse = TRUE, hjust = 0, size = 4) +
  
  # 6. Explicitly define your custom color scheme for the legend
  scale_color_manual(
    name = "Data & Models",
    values = c(
      "Deseasonalized"  = "firebrick",
      "Linear Fit"      = "blue",
      "Quadratic Fit"   = "green4" # A slightly darker green for better visibility
    )
  ) +
  
  # Clean up the styling
  theme_minimal() +
  labs(
    x = "Year",
    y = expression(paste("Average CO" [2], " Concentration (ppm)"))
  )