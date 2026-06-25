# This is an example of a test file for EDA (Exploratory Data Analysis)
source("code/Data.R")
library(corrplot)

# Select relevant columns for correlation analysis
cor_data <- data_imputed[, c("decimal_date", "num_days", "month", "monthly_average", "deseasonalized", 
                            "yearly_average", "daily_average", "yearly_average_deseasonalized", 
                            "daily_average_deseasonalized")]

# Assign clean, professional, and readable variable labels
colnames(cor_data) <- c(
  "Decimal Date",
  "Days of Measurement",
  "Month",
  "Monthly Average",
  "Deseasonalized",
  "Yearly Average",
  "Daily Average",
  "Yearly Average (Deseas.)",
  "Daily Average (Deseas.)"
)

# Generate and customize the correlation plot
corrplot(cor(cor_data), method = "pie", addCoef.col = "black", tl.cex = 0.8, number.cex = 0.7,
         tl.col = "black", tl.srt = 80, addrect = 2, rect.col = "blue", rect.lwd = 1.5, mar = c(0, 0, 1, 0), diag = FALSE)