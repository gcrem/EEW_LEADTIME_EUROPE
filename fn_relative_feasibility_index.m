function idx_pop_intensity_leadtime = fn_relative_feasibility_index(population,intensity,leadtime,w_pop,w_intensity,w_leadtime)

%% function to calculate the lead time between earthquake detection and ground shaking at target site, for multiple earthquake sources
%% Written by: Gemma Cremen, 2020
%% relevant literature: Cremen, G., Galasso, C., & Zuccolo, E. (2020). Could earthquake early warning be effective across Europe?. Nature Communications, (in review)

% Inputs:
% population - mx1 double of ambient populations for each target site with
%              positive median lead-time
% intensity - mx1 double of average seismic intensity for each target site
%              with positive median lead-time 
% leadtime - mx1 double of median lead-time for each target site
%              with positive median lead-time
% w_pop - 1x1 double corresponding to w_P in equation 3 of referenced paper
% w_intensity - 1x1 double corresponding to w_I in equation 3 of referenced paper
% w_leadtime - 1x1 double corresponding to w_L in equation 3 of referenced paper

% Outputs:
% relative_feasibility_index - mx1 double of relative feasibility indices

for i=1:length(population)
prctile_pop(i) = sum(population<=population(i))./length(population);
prctile_intensity(i) = sum(intensity<=intensity(i))./length(intensity);
prctile_leadtime(i) = sum(leadtime<=leadtime(i))./length(leadtime);

idx_pop_intensity_leadtime(i) = ((prctile_pop(i).*w_pop)+(prctile_intensity(i).*w_intensity)+(prctile_leadtime(i).*w_leadtime));

end
