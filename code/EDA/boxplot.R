source("code/Data.R")
library(ggplot2)

data_no_nan$seasonal_deviation <- data_no_nan$monthly_average - data_no_nan$deseasonalized

ggplot(data_no_nan, aes(x = factor(month), y = seasonal_deviation)) +
  # Create a boxplot for each month
  geom_boxplot(fill = "lightblue", color = "darkblue", outlier.size = 0.5) +
  
  # Connect the monthly medians with a line to emphasize the cyclical wave shape
  stat_summary(aes(group = 1), fun = median, geom = "line", color = "firebrick", linewidth = 1) +
  
  theme_minimal() +
  scale_x_discrete(labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", 
                              "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")) +
  labs(
    title = "Climatological CO2 Seasonal Fingerprint",
    x = "Month",
    y = expression(paste("Seasonal CO" [2], " Deviation (ppm)"))
  )