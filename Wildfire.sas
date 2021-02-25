
/********************Data set-up**********************************/
/* Establish library and bring in each of the datasets */

libname Fire "/folders/myfolders/data/Wildfire";

/* Importing the Weather Data */	
FILENAME Weather '/folders/myfolders/data/Wildfire/Weather.csv';

PROC IMPORT DATAFILE=Weather
	DBMS=CSV
	OUT= FIRE.Weather;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=Fire.Weather; RUN;

/* Only retain columns with relevant data/values */

Data Fire.Weather; Set Fire.Weather; 

	drop Smx Smn Srn Sev Ssl Svp Date__yyyymmdd_; 
run;

/* Importing the Fire Data */
FILENAME fire '/folders/myfolders/data/Wildfire/fire.csv';

PROC IMPORT DATAFILE=fire
	DBMS=CSV
	OUT= FIRE.fire;
	GETNAMES=YES;
RUN;

/* Merge the two together ....something not working right with below*/

PROC SQL; 
CREATE TABLE Fire.combined 
AS 
SELECT WEATHER.Date2_ddmmyyyy_, WEATHER.Brigade, WEATHER.Latitude, WEATHER.Longitude, WEATHER.T_Max_oC_, WEATHER.T_Min_oC_, WEATHER.Rain__mm_, WEATHER.Evap_mm_, WEATHER.Radn_MJ_m2_, WEATHER.VP__hPA_, WEATHER.RHmaxT___, WEATHER.RHminT___, FIRE.TypeOfIncident 
FROM FIRE.WEATHER WEATHER 
LEFT JOIN FIRE.FIRE FIRE 
ON 
   ( 
      ( WEATHER.Brigade = FIRE.Brigade ) AND 
      ( WEATHER.Date2_ddmmyyyy_ = FIRE.Date ) 
   ) ; 
QUIT;



/* Create a binary fire column */

data fire.combined; set fire.combined; 
	format fire 8.;
	if TypeOfIncident = " " then fire = 0; 
	else fire = 1; 
run; 

/* Check to make sure all incidents were accounted for...expect ~3700....but only getting 1900???*/
proc means data=fire.combined sum;
	var fire;
run;

/*********************************Geographic Data Exploration*****************************************************/
/* Now move into EDA with the full data set in regards to fire geographic infomration.*/


/* How many unique locations are there in the data set - 267*/

PROC SQL; 
	CREATE TABLE FIRE.LOCATIONS 
	AS 
	SELECT 
	DISTINCT COMBINED.Latitude, COMBINED.Longitude, COMBINED.Brigade 
	FROM FIRE.COMBINED COMBINED; 
QUIT;

/* Adding a column to assist in making a location map, so each location has same "bubble" size */

data fire.locations; set fire.locations; 
	number = 1; 
run; 


/* Now plot them on a map */

ods graphics / reset width=6.4in height=4.8in;

proc sgmap plotdata=FIRE.LOCATIONS;
	openstreetmap;
	bubble x=Longitude y=Latitude size=number/;
run;

ods graphics / reset;



/*****Now create a bubble map representing number of fire incidents per location.****/

/*Create tables to identify  unique locations, with lat long by brogade and then add in count of fires in that location*/ 

PROC SQL; 
	CREATE TABLE FIRE.NUMBER_BY_LOCATION 
	AS 
	SELECT COMBINED.Brigade, SUM(COMBINED.fire) 
	AS fire 
	FROM FIRE.COMBINED COMBINED 
	GROUP BY COMBINED.Brigade; 
QUIT;


PROC SQL; 
	CREATE TABLE FIRE.NUMBER_BY_LOCATION2  
	AS 
	SELECT LOCATIONS.Brigade, LOCATIONS.Latitude, LOCATIONS.Longitude, NUMBER_BY_LOCATION.fire 
	FROM FIRE.LOCATIONS LOCATIONS 
	LEFT JOIN FIRE.NUMBER_BY_LOCATION NUMBER_BY_LOCATION 
	ON 
	   ( LOCATIONS.Brigade = NUMBER_BY_LOCATION.Brigade ) ; 
QUIT;

/*Now plot that on map*/

ods graphics / reset width=6.4in height=4.8in;

proc sgmap plotdata=FIRE.NUMBER_BY_LOCATION2(where=(fire > 20));
	openstreetmap;
	title 'Wild-Fire Incidents by Location (2009-2017)';
	footnote2 justify=left height=10pt '*All incidents incldued that fall in wildfire categories  (non-building or vehicle)  & # incidents >20';
	bubble x=Longitude y=Latitude size=fire/ fillattrs=(color=CXe6c108) 
		transparency=0.16;
run;

ods graphics / reset;
title;
footnote2;



/*****************Explore average weather data and fire*****************/  


/* This creates a frequency of fire incidents table by brogae and brings select weather variable averages with it for gerneal exploration */
PROC SQL; 
	CREATE TABLE fire.weather_x_fire 
	AS 
	SELECT 
	DISTINCT COMBINED.Brigade, AVG(COMBINED.T_Max_oC_) 
	AS T_Max_oC_, AVG(COMBINED.Rain__mm_) 
	AS Rain__mm_, AVG(COMBINED.RHminT___) 
	AS RHminT___, SUM(COMBINED.fire) 
	AS fire 
	FROM FIRE.COMBINED COMBINED 
	GROUP BY COMBINED.Brigade; 
QUIT;

/* Highst frequency city - Explore */ 

PROC SQL; 
	CREATE TABLE Fire.owen
	AS 
	SELECT COMBINED.Date2_ddmmyyyy_, COMBINED.Brigade, COMBINED.Latitude, COMBINED.Longitude, COMBINED.T_Max_oC_, COMBINED.T_Min_oC_, COMBINED.Rain__mm_, COMBINED.Evap_mm_, COMBINED.Radn_MJ_m2_, COMBINED.VP__hPA_, COMBINED.RHmaxT___, COMBINED.RHminT___, COMBINED.TypeOfIncident, COMBINED.fire 
	FROM FIRE.COMBINED COMBINED 
	WHERE 
	   (COMBINED.Brigade = 'OWEN') ; 
QUIT;



/**************************** Logistic Regression ****************/

/* note that all variables were incldued...need to remove some due to multicollinearity, etc.*/
ods noproctitle;
ods graphics / imagemap=on;

proc logistic data=FIRE.COMBINED;
	model fire(event='1')=T_Max_oC_ T_Min_oC_ Rain__mm_ Evap_mm_ Radn_MJ_m2_ 
		VP__hPA_ RHmaxT___ RHminT___ / link=logit technique=fisher;
run;
