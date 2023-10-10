This folder contains data and code to aid in the Karthaus 2022 Mars projects

List of files and description

Name: S_ann_mean.mat
Description: Solar insolation on Mars. The file contains variables
	- lat_rad: latitude in radians, size 180x1
	- time_kyr: time in 1000 years before present, size 21001x1
	- S_ann_mean: Mean annual solar insolation in watts per square meter 1 degree resolution, every 1000 years from -21 million years ago to present day size 21001x180
	- obl_rad: Obliquity in radians every 1000 years from -21 million years ago to present day size 21001x1
	
Name: temp_timedep_FP.m
Description: Simple matlab programme that calculates the temperature profile. The first part of the code returns a steady state profile for constant surface temperature and accumulation. The second part of the code includes changes in surface temperature using the steady state profile as a starting point. 
	
Name: levyetal2014
Description: Folder containing shapefiles with the locations of LDAs, LVFs and CCFs mapped by Levy et al., 2014. 

Name: MOLA_global.mat
Description: Elevation of the Mars surface from the MOLA instrument (deviation from mean surface in metres). The data file contains lat,lon and MOLA_el

Other data available:
Higher resolution MOLA data (approximately 400m) as a tif file
	