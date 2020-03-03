# -*- coding: utf-8 -*-
"""
Created on Mon Feb  3 12:54:11 2020

@author: Saniya Khan
"""
from __future__ import unicode_literals
import urllib.request
import urllib.parse
import pandas as pd
from io import StringIO
from itertools import repeat
api_url = 'https://www.longpaddock.qld.gov.au/cgi-bin/silo'
#replace by actual geocodes
#geocode=pd.DataFrame([['YANKALILLA','-35.494262', '138.362596'], 
#              ['PORT WAKEFIELD','-34.185349', '138.155379']],columns=['Brigade','latitude','longitude'])
list_of_weather=[] 
weather=pd.DataFrame()
def getGeocode():
    geocode= pd.read_csv("coord.csv")
    print(geocode.columns)
    geocode.set_index('Brigade')
    #print("dfdfdfD")
    #print(geocode)
    return geocode;
def buildUrl(lat,long):
    params = {
    'format': 'standard',
    'lat': str(lat),
    'lon': str(long),
    'start': '20090101',
    'finish': '20171231',
    'username': 'sk3862@drexel.edu',
    'password': 'silo'
    }
    url = api_url + '/DataDrillDataset.php?' + urllib.parse.urlencode(params)
    return url    
def sendRequest(url):
    with urllib.request.urlopen(url) as remote:
        data = remote.read()
        s=str(data,'utf-8')
        data_formatted = StringIO(s) 
        df=pd.read_csv(data_formatted)
    return df
def getData(lat,long) :

    return weather

#lat long index
geocode=getGeocode()
for i in range(len(geocode)):
    print(i)
    brigade=[geocode.loc[i,'Brigade']]
    url=buildUrl(geocode.loc[i,'latitude'],  geocode.loc[i,'longitude']) #url for lat long
    df=sendRequest(url) #ping the australian website
    if  i==0: 
        headr=df.iloc[31,:]
        headr.reset_index(inplace=True, drop=True)
        headr.replace('\s+', ',',regex=True,inplace=True) #separate out the header
        headr[0]=headr[0]+",Brigade"+",Latitude"+",Longitude";
        list_of_weather.append(headr) 
    df=df[32:(len(df)-1)]#cleaning remove header, indexes
    df.replace('\s+', ',',regex=True,inplace=True) #make csv space delimited to comma delimited
    df=df.iloc[:,-1]#cleaning 
    df.name=brigade[0]
    formatted_data=df+","+brigade[0]+","+str(geocode.loc[i,'latitude'])+","+str(geocode.loc[i,'longitude'])
    list_of_weather.append(formatted_data)#combine for different locations
    weather=pd.concat(list_of_weather)
#weather = [getData(x, y) for x, y in zip(geocode['latittude'], geocode['longitude'])]
weather.to_csv('weather_lat_long.csv',encoding='utf-8',header=False)#save to file """