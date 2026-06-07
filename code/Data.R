

data <- read.table("data/co2_data.txt", 
                   header = FALSE, 
                   na.strings = c("-9.99", "-1", "-0.99"))

colnames(data) <- c("year", "month", "decimal_date", "monthly_average", 
                    "deseasonalized", "num_days", "st_dev", "unc_mon_mean")

data_no_nan <- na.omit(data)

# Take a look at the result
head(data)
head(data_no_nan)