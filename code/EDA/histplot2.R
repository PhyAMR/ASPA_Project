source("code/Data.R")
library(ggplot2)

ggplot(data_imputed, aes(x = num_days, y = monthly_average)) +
  # 1. Automatically calculate and plot the annual mean as bars
  stat_summary(fun = mean, geom = "bar", fill = "darkcyan", width = 0.8) +
  
  # 2. Automatically calculate and plot the standard deviation error bars
  # This fixes the ymin/ymax error by computing them on the fly from 'y'
  stat_summary(
    fun.min = function(x) mean(x) - sd(x),
    fun.max = function(x) mean(x) + sd(x),
    geom = "errorbar",
    width = 0.4,
    color = "darkgray",
    linewidth = 0.8
  ) +
  
  # Zoom into the y-axis cleanly so differences are visible
  #coord_cartesian(ylim = c(300, 430)) + 
  
  theme_minimal() +
  labs(
    x = "Number of days measured in a month",
    y = expression(paste("Average CO" [2], " Concentration (ppm) (", pm, " ", sigma, ")"))
  )