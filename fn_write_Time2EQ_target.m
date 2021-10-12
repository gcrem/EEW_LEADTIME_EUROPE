function fn_write_Time2EQ_target(earthquake_lat,earthquake_lon,depth,strike, dip,grid_no,stations)

% Written by Gemma Cremen 2020
% writes Time2EQ file 


% INPUTS:
% earthquake_lat: 1 x 1 double of earthquake latitude 
% earthquake_lon: 1 x 1 double of earthquake longitude
% depth:          1 x 1 double of earthquake depth (km) 
% strike:         1 x 1 double of earthquake strike angle in decimal
%                       degrees
% dip:            1 x 1 double of earthquake dip angle in decimal degrees
% grid no:        1 x 1 double of earthquake number (j in
%                       lead_time_Europe_engine)
% stations:       3 x 1 cell of station name strings for three closest
%                       stations


% Creating and writing the run file in the required format 
filename='Time2EQ.in';
fileID=fopen(filename,'w');


zero_line = ['\nEQFILES time/layer time/obs/synth.obs'];


first_line = ['\nEQMECH NONE ' num2str(sprintf('%.1f',strike)) ' ' num2str(sprintf('%.1f',dip)) ' 0.0' ];
second_line = ['\nEQMODE SRCE_TO_STA'];
third_line = ['\nEQSRCE Source_' num2str(grid_no) ' LATLON ' num2str(earthquake_lat) ' ' num2str(earthquake_lon) ' ' num2str(sprintf('%.1f',depth)) ' 0.0'];

fprintf(fileID,zero_line);
fprintf(fileID,first_line);
fprintf(fileID,second_line);
fprintf(fileID,third_line);


for i=1:length(stations)
current_line_P = ['\nEQSTA ' stations{i} ' P '  'GAU 0.2 '  'GAU 0.2 '];
current_line_S = ['\nEQSTA ' stations{i} ' S '  'GAU 0.2 '  'GAU 0.2 '];
  
fprintf(fileID,current_line_P);
fprintf(fileID,current_line_S);
end

current_line_P = ['\nEQSTA T_1 P '  'GAU 0.2 '  'GAU 0.2 '];
current_line_S = ['\nEQSTA T_1 S '  'GAU 0.2 '  'GAU 0.2 '];
  
fprintf(fileID,current_line_P);
fprintf(fileID,current_line_S);

% set VPVS ratio <1 to so that s-wave travel time grids are used 

second_last_line = ['\nEQVPVS -1.0'];
last_line = ['\nEQQUAL2ERR 0.1 0.2 0.4 0.8 99999.9'];

fprintf(fileID,second_last_line);
fprintf(fileID,last_line);









fclose('all')



