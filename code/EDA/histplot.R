source("code/Data.R")
library(ggplot2)

ggplot(data_no_nan, aes(x = decimal_date, y = monthly_average)) +
  # Add the error bars first so they sit slightly behind the points
  geom_errorbar(aes(ymin = monthly_average - st_dev, 
                    ymax = monthly_average + st_dev), 
                width = 0.2,            # Width of the whisker caps
                color = "darkgray",     # Color of the bars
                linewidth = 0.8) +      # Thickness of the bars
  # Add the scatter points
  geom_point(color = "firebrick", size = 0.2) +
  # Clean up the styling
  theme_minimal() +
  labs(
    x = "Month",
    y = "Average CO2 Concentration (ppm) ($\pm \sigma$)"
  )