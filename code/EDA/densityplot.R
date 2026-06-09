source("code/Data.R")
library(GGally)
library(dplyr)
library(ggplot2)

# 1. Clean the data subset and make 'month' a factor
eda_subset <- data_no_nan %>% 
  select(monthly_average, deseasonalized, st_dev, unc_mon_mean, month, num_days) %>% 
  mutate(month = factor(month, labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", 
                                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")))

# 2. Build explicit formatting wrappers for complete structural control
custom_scatter <- function(data, mapping, ...) {
  ggplot(data = data, mapping = mapping) + 
    geom_point(alpha = 0.3, size = 0.3, color = "dimgray", ...)
}

custom_boxplot <- function(data, mapping, ...) {
  ggplot(data = data, mapping = mapping) + 
    geom_boxplot(color = "darkcyan", fill = "lightcyan", outlier.size = 0.5, ...)
}

# NEW: Custom function to generate violin plots for data combinations
custom_violin <- function(data, mapping, ...) {
  ggplot(data = data, mapping = mapping) + 
    geom_violin(color = "purple4", fill = "plum1", alpha = 0.5, scale = "width", ...)
}

# 3. Generate the matrix with violin plots on top
ggpairs(
  eda_subset,
  title = "Distribution Matrix of CO2 Variables",
  
  # Diagonal: Pure density curves for continuous data
  diag = list(
    continuous = wrap("densityDiag", fill = "lightsteelblue", alpha = 0.7),
    discrete = wrap("barDiag", fill = "lightsteelblue")
  ),
  
  # Lower Triangle: Scatter plots and box plots
  lower = list(
    continuous = custom_scatter
  ),
  
  # Upper Triangle: Violin plots for combos, density contours for continuous pairs
  upper = list(
    continuous = wrap("density", color = "darkslateblue", linewidth = 0.4), 
    combo = custom_violin
  )
) +
  theme_minimal() +
  theme(
    panel.grid.major = element_blank(), 
    axis.text = element_text(size = 7),  
    strip.text = element_text(size = 9, face = "bold")
  )