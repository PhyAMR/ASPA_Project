

data <- read.table("data/co2_data.txt", 
                   header = FALSE, 
                   na.strings = c("-9.99", "-1", "-0.99"))

colnames(data) <- c("year", "month", "decimal_date", "monthly_average", 
                    "deseasonalized", "num_days", "st_dev", "unc_mon_mean")

data_no_nan <- na.omit(data)
data_no_nan$yearly_average <- ave(data_no_nan$monthly_average, data_no_nan$year, FUN = mean)
data_no_nan$daily_average <- ave(data_no_nan$monthly_average, data_no_nan$num_days, FUN = mean)

data_no_nan$yearly_average_deseasonalized <- ave(data_no_nan$deseasonalized, data_no_nan$year, FUN = mean)
data_no_nan$daily_average_deseasonalized <- ave(data_no_nan$deseasonalized, data_no_nan$num_days, FUN = mean)

data_no_nan$seasonal_deviation <- data_no_nan$monthly_average - data_no_nan$deseasonalized

# Impute missing values with the mean of the variable for the same calendar month,
# instead of dropping the rows (as done in data_no_nan)
data_imputed <- data
for (col in names(data_imputed)) {
  if (anyNA(data_imputed[[col]])) {
    month_mean <- ave(data_imputed[[col]], data_imputed$month, FUN = function(x) mean(x, na.rm = TRUE))
    data_imputed[[col]][is.na(data_imputed[[col]])] <- month_mean[is.na(data_imputed[[col]])]
  }
}
data_imputed$num_days <- as.integer(data_imputed$num_days)
data_imputed$yearly_average <- ave(data_imputed$monthly_average, data_imputed$year, FUN = mean)
data_imputed$daily_average <- ave(data_imputed$monthly_average, data_imputed$num_days, FUN = mean)

data_imputed$yearly_average_deseasonalized <- ave(data_imputed$deseasonalized, data_imputed$year, FUN = mean)
data_imputed$daily_average_deseasonalized <- ave(data_imputed$deseasonalized, data_imputed$num_days, FUN = mean)

data_imputed$seasonal_deviation <- data_imputed$monthly_average - data_imputed$deseasonalized
# Take a look at the result
head(data)
head(data_no_nan)
head(data_imputed)