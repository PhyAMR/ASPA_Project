source("code/Data.R")
library(ggplot2)
library(patchwork)
library(dplyr)

# --- PLOT 1: Uncertainty and Std Dev Over Time ---
# We use geom_line to see if instrument precision or environmental variance 
# has changed over the decades. 
plot_time <- ggplot(data_imputed, aes(x = decimal_date)) +
  # Plot standard deviation of daily measurements
  geom_line(aes(y = st_dev, color = "Daily St. Dev."), linewidth = 0.5, alpha = 0.7) +
  # Plot calculated uncertainty of the monthly mean
  geom_line(aes(y = unc_mon_mean, color = "Monthly Mean Uncertainty"), linewidth = 0.5, alpha = 0.7) +
  
  scale_color_manual(
    name = "Metric",
    values = c("Daily St. Dev." = "dimgray", "Monthly Mean Uncertainty" = "firebrick")
  ) +
  theme_minimal() +
  theme(legend.position = "bottom") +
  labs(
    x = "Year",
    y = "Uncertainty / Standard Deviation (ppm)",
    title = "Uncertainty Trends Over Time"
  )

# --- PLOT 2: Standard Deviation by Month ---
# This checks if the variation in daily CO2 changes depending on the season 
# (e.g., higher variance during summer drawdown months).
plot_monthly <- ggplot(data_imputed, aes(x = factor(month), y = st_dev)) +
  # Boxplot to show the distribution of standard deviations for each month across all years
  geom_boxplot(fill = "lightsteelblue", color = "black", outlier.size = 0.5) +
  # Add a trend line connecting the monthly means
  stat_summary(aes(group = 1), fun = mean, geom = "line", color = "darkblue", linewidth = 1) +
  
  scale_x_discrete(labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", 
                              "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")) +
  theme_minimal() +
  labs(
    x = "Month",
    y = "Daily Standard Deviation (ppm)",
    title = "Daily Variance by Season"
  )

# --- COMBINE THEM SIDE-BY-SIDE ---
combined_uncertainty <- plot_time + plot_monthly + 
  plot_annotation(
    title = "Data Quality and Heteroskedasticity Assessment",
    tag_levels = "A"
  )

# Display the final layout
combined_uncertainty