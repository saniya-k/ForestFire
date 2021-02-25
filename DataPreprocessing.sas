LIBNAME ProjectD "/folders/myfolders/ProjectD";
data ProjectD.weather1; set ProjectD.weather;
	rename VAR4=TMax VAR6=Tmin VAR12=Radiation VAR16=RHmaxT VAR17=RHminT Date2_mmddyyyy_ =Date;
	drop Date__yyyymmdd_ Smx Smn Srn Sev Svp Ssl S_No ;
run;
