function fn_write_runfile_P(latitude_origin,longitude_origin)


% Written by Gemma Cremen
% writes Run file required to create travel time grid


% INPUTS:
% latitude_origin:  1 x 1 double with latitude of geographic origin of 
%                   coordinate system
% longitude_origin: 1 x 1 double with latitude of geographic origin of 
%                   coordinate system


% Creating and writing the run file in the required format 
filename='RunFile.run';
fileID=fopen(filename,'w');

first_line = ['CONTROL 1 54321'];
second_line = ['\nTRANS SIMPLE ' num2str(latitude_origin) ' ' num2str(longitude_origin) ' 0.0'];
third_line = ['\nINCLUDE ./run/Vel2Grid_P.in'];
fourth_line = ['\nINCLUDE ./run/Grid2Time_P.in'];

fprintf(fileID,first_line)
fprintf(fileID,second_line)
fprintf(fileID,third_line)
fprintf(fileID,fourth_line)




fclose('all')
