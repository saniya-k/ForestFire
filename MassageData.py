# -*- coding: utf-8 -*-
"""
Created on Sun Mar  1 14:54:25 2020

@author: Saniya Khan
"""
import pandas as pd
data= pd.read_csv("weather_lat_long.csv")
print(data)
col_names=["Date (yyyymmdd)","Day","T.Max(oC)","Smx","T.Min(oC)","Smn","Rain (mm)","Srn","Evap(mm)","Sev", "Radn(MJ/m2)","Ssl" ,"VP (hPA)","Svp","RHmaxT(%)" ,"RHminT(%)" ,"Date2(ddmmyyyy)","Brigade","Latitude","Longitude"]
print(data.row)
df = pd.DataFrame(data.row.str.split(',',n=19).tolist(),
                                   columns = col_names)
print(df.head())
df.to_csv("Weather_formatted_convert.csv")