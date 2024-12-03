# Gold-Silver-Time-Series

## Project Overview

This project explores the historical relationship between gold and silver prices through comprehensive time series analysis. Utilizing data from 1915 to 2024, the study aims to understand whether silver prices can serve as a predictive indicator for gold prices. The project implements various statistical and machine learning models, including ARIMA, ARIMAX, and Vector Autoregression (VAR), to analyze and forecast these interrelated financial time series.

## Key Objectives

- Analyze the individual time series properties of gold and silver prices, including stationarity, seasonality, and trends.
- Evaluate the potential of silver prices as an external regressor to improve forecasts of gold prices.
- Perform residual diagnostics, model evaluation, and forecast accuracy testing using RMSE and MAE.
- Provide actionable insights and recommendations for future improvements.


## Features

- **Data Preprocessing**: Transformation of raw data using differencing and Box-Cox transformations for stationarity.
- Modeling Techniques:
  - ARIMA and ARIMAX for univariate and multivariate time series modeling.
  - Cross-correlation analysis and Granger causality tests to explore the lead-lag relationships between gold and silver.
  - VAR modeling for simultaneous multivariate forecasting.
- Forecasting: Short-term forecasting of gold prices using ARIMAX with silver prices as an external predictor.
- Visualization: Includes ACF, PACF, residual analysis, and cross-correlation plots.

## Results

- The ARIMAX model demonstrated moderate success in leveraging silver prices to predict gold prices, with RMSE and MAE values of approximately 253 and 209, respectively.
- Residual analysis supported the adequacy of the ARIMAX model, showing minimal autocorrelation and a near-normal distribution of residuals.
- VAR modeling indicated a strong interdependence between the two time series but highlighted areas for further refinement.


## Future Work

- Explore additional external regressors, such as macroeconomic indicators or geopolitical events, to improve forecast accuracy.
- Experiment with more advanced machine learning models, including LSTM or XGBoost, for capturing non-linear relationships.
- Extend the analysis to include out-of-sample forecasting and model validation.
