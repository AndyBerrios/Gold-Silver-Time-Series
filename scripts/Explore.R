
################################################################################
#libraries and data
library(tidyverse)
library(gridExtra)
library(tseries) # for stationarity testing
library(forecast) 

gold <- read.csv('data/Gold_Historical.csv', skip = 9, header = TRUE)
silver <- read.csv('data/Silver_Historical.csv', skip = 9, header = TRUE)

full <- left_join(gold, silver, by = 'date', suffix = c('_gd','_sv'), keep = FALSE)


################################################################################
# Exploratory plots
#par(mfrow=c(2,1))  

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



