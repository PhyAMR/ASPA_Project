source("code/Data.R")
library(ggplot2)


ggplot(data_no_nan, aes(x = decimal_date)) +
  # 1. Error bars for monthly average
  geom_errorbar(aes(ymin = monthly_average - unc_mon_mean, 
                    ymax = monthly_average + unc_mon_mean), 
                width = 0.2,            
                color = "darkgray",     
                linewidth = 0.8) +      
  
  # 2. Monthly Average Points
  geom_point(aes(y = monthly_average, color = "Monthly Average"), size = 0.5) +
  
  # 3. Deseasonalized Line & Points (Grouped under "Deseasonalized")
  geom_line(aes(y = deseasonalized, color = "Deseasonalized"), linewidth = 0.5) +
  geom_point(aes(y = deseasonalized, color = "Deseasonalized"), size = 0.8, alpha = 0.6) +
  
  scale_color_manual(
    name = "Data",
    values = c(
      "Monthly Average" = "black",
      "Deseasonalized"  = "firebrick" 
    )
  ) +
  
  # Clean up the styling
  theme_minimal() +
  labs(
    x = "Year",
    y = expression(paste("Average CO" [2], " Concentration (ppm) (", pm, " ", sigma, ")"))
  )

