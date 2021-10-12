function [p_time,s_time]= fn_extract_tt()

% Written by Gemma Cremen 2020
% extracts P- and S-wave travel times calculated by Time2EQ program


% INPUTS:
% p-time:  4 x 1 double of P-wave travel times to three closest stations
%          and target site
% s-time:  4 x 1 double of S-wave travel times to three closest stations
%          and target site 


formatSpec = '%*s %f';
    
%fileID  = fopen('synth.obs.HYPO','r');
fileID  = fopen('synth.obs.INVC','r');
 fgetl(fileID);
times=fscanf(fileID,formatSpec,[2 Inf]);

p_time= times(1,:);
s_time = times(2,:);

