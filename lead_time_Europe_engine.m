
function lead_time = lead_time_Europe_engine(target_lat,target_lon,Rjb,source_lat,source_lon,source_depth,source_strike,source_dip,velocity_model,VS30,SOF,mag,station_lat,station_lon,station_depth,station_elev,station_code)

%% function to calculate the lead time between earthquake detection and ground shaking at target site, for multiple earthquake sources
%% Written by: Gemma Cremen, 2020
%% relevant literature: Cremen, G., Galasso, C., & Zuccolo, E. (2020). Could earthquake early warning be effective across Europe?. Nature Communications, (in review)

% Inputs:
% target_lat - 1x1 double of target site latitude
% target_lon - 1x1 double of target site longitude 
% Rjb - nx1 double of n source-to-target site Joyner-Boore distances
% source_lat - nx1 double of n earthquake latitudes
% source_lon - nx1 double of n earthquake longitudes 
% source_depth - nx1 double of n earthquake depths (positive = down)
% source_strike - nx1 double of n earthquake strike angles in decimal degrees
% source_dip - nx1 double of n earthquake dip angles in decimal degrees
% velocity model - px7 double of p soil layers. Columns are as follows: 
%i.	Layer – description of soil layer (text format), e.g. ‘sediments’,’water’ etc.
%ii.	Depth (km) – depth to top of layer (use negative values for layers above 0)
%iii.	VpTop – P velocity at top of layer in km/s
%iv.	VpGrad – Linear P velocity gradient in km/s/km (use 0 if missing)
%v.	     VsTop – S velocity at top of layer in km/s
%vi.	VsGrad – Linear S velocity gradient in km/s/km (use 0 if missing)
%vii.	rhoTop – density at top of layer in km/m^3
%viii.	rhoGrad – density gradient in kg/m^3/km
 
% VS30 - VS30 value at target site, for input to Akkar Bommer (2014) ground
% motion model for Europe
% SOF - nx1 style-of-faulting for each earthquake source, for input to
% Akkar Bommer (2014) ground motion model for Europe. 
% mag - nx1 double of magnitudes for each earthquake source
% station_lat - kx1 double of k station latitudes
% station_lon - kx1 double of k station longitudes
% station_depth -kx1 double of k station depths in km (positive downwards)
% station_elev - kx1 double of k station elevations in km (use either
% station_depth or station_elev- use negative upwards for station_elev)
% station_code - kx1 cell of station name strings 


% Outputs
% lead_time - nx1 lead times at target site for n earthquakes (s)


%Assumptions:
% Lead time = s-wave arrival time - p-wave arrival time - (note that a
% custom delay should be added by the user after)


grid_spacing = [10 10 10]; % spacing in x\y\z direction in km

% determine epicentral distance between target site and each source 
distance_target = fn_coordinatestoDistance(target_lat,source_lat,target_lon,source_lon);



% calculate median PGA that results at the target site, for each earthquake
% source 
y_PGA=zeros(length(distance_target),1);
for m=1:length(distance_target)
[y_PGA(m),~,~,~,~,~] = fn_AB_GMPE(Rjb(m),'jb',mag(m),SOF(m),VS30);
end


% find earthquake sources that produce at least y_PGA = 0.05 g at the
% target site - ignore all other sources in the calculation
finder_pga = find(y_PGA>=0.05);
if isempty(finder_pga)
    error('No earthquake sources produce strong enough shaking at the target site')
end




distance_target_refined = distance_target(finder_pga);

% loop through all sources that satisfy the y_PGA criterion
for j=1:length(distance_target_refined)

earthquake_lat = source_lat(finder_pga(j));
earthquake_lon = source_lon(finder_pga(j));
earthquake_depth = source_depth(finder_pga(j));
earthquake_strike = source_strike(finder_pga(j)); 
earthquake_dip = source_dip(finder_pga(j)); 

% find the distance from the source to each station, and sort distances
% from lowest to highest 
distance_earthquake_station = fn_coordinatestoDistance(station_lat,earthquake_lat,station_lon,earthquake_lon);
[~,idx_sort] = sort(distance_earthquake_station,'ascend');


% proceed only with the 3 closest stations to the earthquake
station_lat_current = station_lat(idx_sort(1:3));
station_lon_current = station_lon(idx_sort(1:3));
station_depth_current = station_depth(idx_sort(1:3));
station_elev_current = station_elev(idx_sort(1:3));
station_code_current = station_code(idx_sort(1:3));

stations_current=station_code_current;



% get parameters of grid for travel time calculation
latitude_origin = min([station_lat_current;earthquake_lat;target_lat]);
longitude_origin = min([station_lon_current;earthquake_lon;target_lon]);

latitude_high =  max([station_lat_current;earthquake_lat;target_lat]);
longitude_high =  max([station_lon_current;earthquake_lon;target_lon]);

% get maximum difference between furthest coordinates for grid numbers 
distance_grid_num = fn_coordinatestoDistance(latitude_high,latitude_origin,longitude_high,longitude_origin);

grid_num_xy = ceil(distance_grid_num./grid_spacing(1))+3;


grid_origin = [-1,-1,-ceil(max([station_elev_current;0]))]; % origin of grid in x\y\z direction relative to true origin






% delete all previous versions of velocity and time grids/files
% delete('C:\Users\ucesgjc\Dropbox\UCL Postdoc\Lead time Damage Maps\WP3.1.2 Calculations\PRESTo Engine\model\*')
% delete('C:\Users\ucesgjc\Dropbox\UCL Postdoc\Lead time Damage Maps\WP3.1.2 Calculations\PRESTo Engine\time\*')
% delete('C:\Users\ucesgjc\Dropbox\UCL Postdoc\Lead time Damage Maps\WP3.1.2 Calculations\PRESTo Engine\time_noise\*')



grid_num = [grid_num_xy,grid_num_xy,5]; % number of nodes in x\y\z direction


% write Vel2Grid file, for running Vel2Grid program
fn_write_Vel2Grid_P(grid_num,grid_origin,grid_spacing,velocity_model)
fn_write_Vel2Grid_S(grid_num,grid_origin,grid_spacing,velocity_model)


% write Grid2Time file, for running Grid2Time program
fn_write_Grid2Time_P_target(stations_current,station_lat_current,station_lon_current,station_depth_current,station_elev_current,target_lat,target_lon)
fn_write_Grid2Time_S_target(stations_current,station_lat_current,station_lon_current,station_depth_current,station_elev_current,target_lat,target_lon)

% write runfile, for running Vel2Grid and Grid2Time programs (P-waves)
fn_write_runfile_P(latitude_origin,longitude_origin)

% run Vel2Grid and Grid2Time programs (P-waves)
fn_run_Vel2Grid_Grid2Time()

% write runfile, for running Vel2Grid and Grid2Time programs (S-waves)
fn_write_runfile_S(latitude_origin,longitude_origin)

% run Vel2Grid and Grid2Time programs (S=waves)
fn_run_Vel2Grid_Grid2Time()


% write Time2EQ file, for running Time2EQ program
fn_write_Time2EQ_target(earthquake_lat,earthquake_lon,earthquake_depth,earthquake_strike,earthquake_dip,j,stations_current) 


% write runfile, for running Time2EQ program
fn_write_runfile_Time2EQ(latitude_origin,longitude_origin)

% run Time2EQ program
fn_run_Time2EQ()



% extract travel times calculated by Time2EQ program
[p_time,s_time]= fn_extract_tt(); 

% calculate lead time for jth earthquake source 
lead_time(j) = s_time(end)- (max(p_time(1:3)));


end
