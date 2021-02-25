# Australian Forest Fire Prediction

*** Data Acquisition, Exploratory data analysis and prediction of Australian Forest Fires***

A detailed report is attached here (Group 1_Team WILDFIRE.pdf)

![banner](/images/banner.jpg)

## Introduction
Trends in both general weather conditions and incidents of wildfire were analyzed in
southern Australia over a time period spanning 2009 to 2017. Data acquisition & cleaning was done in python and australian government website APIs were leveraged to access relevant datasets.
 Through the collection of various data sets and appropriate cleaning and merging, a comprehensive data set of observations was constructed over this time period. Based on extensive exploratory analysis and regression, trends in weather, such as heightened fire
risks due do seasonality of temperature and rainfall factors was clearly demonstrated. All data preprocessing
and analysis was focused within the SAS Studio University Edition software.

## Problem Statement
This study aims to address several research questions focused on identifying trends
in weather and incidents of wildfire in Southern Australia over the time period of 2009 to 2017. Further,
quantitative examination of the relationship between these two observations – weather and incidents
of wildfire – will follow to determine any correlation between various weather factors and fire
occurrence

## Data Exploration 

**Relevant Research Questions: **
• What are the overall trends of incidents of wildfire in Southern Australia – frequency, time of
year, type of incident etc?
• What is the overall trend of basic weather data over the period of analysis in Southern
Australia?
• What weather factors are significant indicators of incidents of wildfire in Southern Australia?
Seasonal cycle for Weather Data (Maximum Temperature) :
![Tmax](/images/Tmax.png)


## Model Building

Logistic Regression was used used to predict the fire incidents. As the data was highly imbalanced, we decided to undersample the majority class using stratified random sampling using each month data and we were able to get an **AUC of 73.4%** which seems like a decent estimate. 

![ROC](/images/results.png)

## Summary

1. Maximum Temperature was the most significant variable in this regression followed by radiation and vapor pressure.
2. Next steps would be include a broader time horizon,  identifying cities with higher fire incidents and including a lag variable which counts fire
incidents in the preceding three days in the city itself, as well as the adjacent city. The theory behind
creating this variable is that proximity may result in fires spreading or conditions being similar
enough to affect the likelihood of another fire event.


