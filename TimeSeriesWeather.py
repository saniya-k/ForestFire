# -*- coding: utf-8 -*-
"""
Created on Fri Mar  6 15:52:30 2020

@author: Saniya Khan
"""

import numpy as np
import seaborn as sns
import pandas as pd
import matplotlib as plt

weather=pd.read_csv("Weather_formatted_convert.csv")
weather=weather[['Day','T.Max(oC)','T.Min(oC)','Rain (mm)','Evap(mm)','Radn(MJ/m2)','VP (hPA)','RHmaxT(%)','RHminT(%)','Date2(mmddyyyy)','Brigade','Latitude','Longitude']]
weather.rename(columns={"Date2(mmddyyyy)":"Date"},errors="raise",inplace = True)
weather['Date']=pd.to_datetime(weather['Date'])
print(weather.isnull().sum())
weather=weather.set_index('Date')
y=weather['T.Max(oC)'].resample('M').mean()
print(y['2017':])
print(y['2009':])
print(y['2008':])
sns.set()
y.plot(figsize=(15,6))
plt.show()
y1=weather['T.Min(oC)'].resample('M').mean()
y1.plot(figsize=(15,6))