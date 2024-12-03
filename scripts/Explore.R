
################################################################################
#libraries and data
library(tidyverse)
library(gridExtra)
library(tseries) # for stationarity testing
library(forecast) 
library(lmtest) # for granger test of corr
library(vars) # check both series influence each othe

gold <- read.csv('data/Gold_Historical.csv', skip = 9, header = TRUE)
silver <- read.csv('data/Silver_Historical.csv', skip = 9, header = TRUE)

full <- left_join(gold, silver, by = 'date', suffix = c('_gd','_sv'), keep = FALSE)

full$nominal_gd <- NULL
full$nominal_sv <- NULL 

################################################################################
# Exploratory plots

a <- full %>% ggplot(aes(x = date, y = real_gd)) +
  geom_line() +
  labs(title = "Gold Prices Over Time", 
       subtitle = "Price per Oz, USD", 
       caption = "Figure 1", 
       x = "Date", 
       y = "Price (inflation included)") +
  scale_x_date(breaks = seq(as.Date("1920-01-01"), as.Date("2024-01-01"), by = "10 years"), 
               date_labels = "%Y") + 
  theme_minimal() + 
  theme(
    plot.title = element_text(size = 23, face = "bold"),    # Title size
    plot.subtitle = element_text(size = 19),               # Subtitle size
    axis.title = element_text(size = 19),                  # Axis labels size
    axis.text = element_text(size = 17),                   # Axis tick labels size
    legend.title = element_text(size = 19),                # Legend title size
    legend.text = element_text(size = 17),                 # Legend text size
    plot.caption = element_text(size = 15)                 # Caption size
  )

b <- full %>% ggplot(aes(x = date, y = real_sv)) +
  geom_line() +
  labs(title = "Silver Prices Over Time", 
       subtitle = "Price per Oz, USD", 
       caption = "Figure 2", 
       x = "Date", 
       y = "Price (inflation included)") +
  scale_x_date(breaks = seq(as.Date("1920-01-01"), as.Date("2024-01-01"), by = "10 years"), 
               date_labels = "%Y") + 
  theme_minimal() + 
  theme(
    plot.title = element_text(size = 23, face = "bold"),    # Title size
    plot.subtitle = element_text(size = 19),               # Subtitle size
    axis.title = element_text(size = 19),                  # Axis labels size
    axis.text = element_text(size = 17),                   # Axis tick labels size
    legend.title = element_text(size = 19),                # Legend title size
    legend.text = element_text(size = 17),                 # Legend text size
    plot.caption = element_text(size = 15)                 # Caption size
  )

grid.arrange(a, b , ncol = 1)

# Plot overlay
full %>% ggplot() +
  geom_line(aes(x = date, y = real_gd, color = "Gold"), size = 1) +
  geom_line(aes(x = date, y = real_sv, color = "Silver"), size = 1) +
  labs(title = "Gold and Silver Prices Over Time",
       x = "Date",
       y = "Price (inflation included)",
       caption = "Figure 3") +
  scale_x_date(breaks = seq(as.Date("1920-01-01"), as.Date("2024-01-01"), by = "10 years"), 
               date_labels = "%Y") +
  scale_color_manual(values = c("Gold" = "gold", "Silver" = "gray")) +
  theme_minimal() + 
  theme(
    plot.title = element_text(size = 23, face = "bold"),    # Title size
    plot.subtitle = element_text(size = 19),               # Subtitle size
    axis.title = element_text(size = 19),                  # Axis labels size
    axis.text = element_text(size = 17),                   # Axis tick labels size
    legend.title = element_text(size = 19),                # Legend title size
    legend.text = element_text(size = 17),                 # Legend text size
    plot.caption = element_text(size = 15)                 # Caption size
  )

################################################################################
# ACF testing
acf(full$real_gd, main = 'ACF of Real Gold Prices',sub = 'Figure 4')


acf(full$real_sv, main = 'ACF of Real Silver Prices', sub = 'Figure 5')


###################################
# Differencing
gold_diff <- diff(full$real_gd)
acf(gold_diff, main = "ACF of Differenced Gold Series")

silver_diff <- diff(full$real_sv)
acf(silver_diff, main = "ACF of Differenced Silver Series")

# Augmented Dickey-Fuller (ADF) test, to confirm stationarity:
adf.test(gold_diff) 
adf.test(silver_diff) 

################################################################################
# Modeling using: auto.arima

# transforming into time series objects
gold_ts <- ts(gold$real, start = c(1915,1), frequency = 12)
silver_ts <- ts(silver$real, start = c(1915,1), frequency = 12)

# Fit ARIMA model
gd_model <- auto.arima(gold_ts, d = 1)
sv_model <- auto.arima(silver_ts, d = 1)
# View model summary
summary(gd_model)
summary(sv_model)


##################################
# Improving Gold Model

par(mfrow=c(2,1)) 
acf(gold_diff, main = "ACF of Differenced Gold Series")
pacf(gold_diff, main = "PACF of Differenced Gold Series")


lambda <- BoxCox.lambda(gold_ts)
gold_trans <- BoxCox(gold_ts, lambda)

gd_model_2 <- auto.arima(gold_trans)
summary(gd_model_2)



################################################################################
# Correaltion between both differentiated datasets
ccf(gold_diff, silver_diff, main = "Cross-Correlation Between Gold and Silver")

# Granger causality test to test if correlation is significant
grangertest(gold_diff ~ silver_diff, order = 2)  # Adjust `order` based on lags


################################################################################
# MULIVARIATE MODELS
# Var to see if both series influence each other

# The VAR() function implements a Vector Autoregression (VAR) model, 
# a statistical model used to analyze and predict multivariate time series data. 
# Unlike univariate models, VAR considers multiple dependent time series, 
# allowing for lagged values of all variables to influence each variable in the system.
# It assumes all variables are interdependent and uses lagged values of each series 
# to predict the current values of all series in the model. 
# This makes it particularly useful for capturing relationships and 
# dependencies between time series variables, such as gold and silver prices.

# Fit VAR model
var_model <- VAR(full[, c("real_gd", "real_sv")], p = 2, type = "const")  # Adjust `p` as needed

summary(var_model)


arimax_model <- auto.arima(gold_ts, xreg = silver_ts)
summary(arimax_model)









