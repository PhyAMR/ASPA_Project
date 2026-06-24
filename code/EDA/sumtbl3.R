source("code/Data.R")
library(skimr)
library(dplyr)
library(knitr)

# 1. Select the core variables you want to summarize
summary_data <- data_imputed %>% 
  select(year, monthly_average, deseasonalized, num_days, st_dev, unc_mon_mean)

# 2. Skim the data, convert it to a regular data frame, and select clean summary metrics
skim_table <- skim(summary_data) %>% 
  as.data.frame() %>% 
  select(
    Variable = skim_variable,
    Missing = n_missing,
    Mean = numeric.mean,
    SD = numeric.sd,
    Min = numeric.p0,
    Median = numeric.p50,
    Max = numeric.p100
  )

# Table rendered separately in main.qmd