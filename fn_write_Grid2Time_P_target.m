function fn_write_Grid2Time_P_target(station,station_lat,station_lon,station_depth,station_elev,target_lat,target_lon)

% Written by Gemma Cremen 2020

% writes Grid2Time file required to create travel time grid

% INPUTS:
% station:         1 x n string of n station names
% station_lat:      1 x n double of n station latitudes
% station_lon:      1 x n double of n station longitudes 
% station_depth:    1 x n double of n station depths (positive down)
% station_elev:     1 x n double of n station elevations (positive up)

% Creating and writing the Grid2Time file in the required format 
filename='Grid2Time_P.in';
fileID=fopen(filename,'w');

first_line = ['GTFILES  ./model/layer  ./time/layer P '];
second_line = ['\nGTMODE GRID3D ANGLES_NO'];



fprintf(fileID,first_line)
fprintf(fileID,second_line)


for i=1:length(station)
  
current_line = ['\nGTSRCE ' station{i} ' LATLON '  num2str(station_lat(i)) ' ' num2str(station_lon(i)) ' ' num2str(station_depth(i)) ' ' num2str(station_elev(i))];
fprintf(fileID,current_line)

end

current_line = ['\nGTSRCE T_1 LATLON '  num2str(target_lat) ' ' num2str(target_lon) ' 0.0 0.0 '];
fprintf(fileID,current_line)


cd('C:\Users\ucesgjc\Dropbox\UCL Postdoc\Lead time Damage Maps\WP3.1.2 Calculations')


last_line = ['\nGT_PLFD  1.0e-3  0'];
fprintf(fileID,last_line)

fclose('all')

 
