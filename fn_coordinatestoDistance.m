function distance  = fn_coordinatestoDistance(station_lat,eq_lat,station_lon,eq_lon)
% Written by Gemma Cremen 2016
% Calculates distances between two points  

% INPUTS:
% station_lat:      1 x 1 double of location 1 latitude
% eq_lat:           1 x 1 double of location 2 latitude
% station_lon:      1 x 1 double of location 1 longitude
% eq_lon:           1 x 1 double of location 2 longitude

% OUTPUTS:
% distance:         1 x 1 estimate of distance (km) 


station_lat = station_lat.*pi/180;
eq_lat = eq_lat.*pi/180;
station_lon = station_lon.*pi/180;
eq_lon = eq_lon.*pi/180;

% radius of the earth
R = 6371000;
deltlat = station_lat - eq_lat;
deltlong = station_lon-eq_lon;

a = sin(deltlat./2).*sin(deltlat./2) +(cos(station_lat).*cos(eq_lat).*sin(deltlong./2).*sin(deltlong./2));
c=2.*atan2(sqrt(a),sqrt(1-a));
distance = R.*c.*10^-3;

end
