# This is an example of a test file for EDA (Exploratory Data Analysis)
source("code/Data.R")
library(corrplot)

corrplot(cor(data_no_nan), method = "pie", addCoef.col = "black", tl.cex = 0.8, number.cex = 0.7,
         tl.col = "black", tl.srt = 45, addrect = 2, rect.col = "blue", rect.lwd = 1.5)