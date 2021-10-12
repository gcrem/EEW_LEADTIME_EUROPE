function fn_write_Vel2Grid_S(grid_num,grid_origin,grid_spacing,velocity_model)

% Written by Gemma Cremen, 2020


% writes Vel2Grid file required to create travel time grid


% INPUTS:
% grid_num:         1 x 3 double of travel_time grid node number in space
%                   (x/y/z)
% grid_origin       1 x 3 double of grid origin in space (x/y/z) relative
%                   to true origin
% grid_spacing:     1 x 3 double of spacing (km) between nodes (x/y/z) in
%                   travel time grid
% velocity model:   b x 7 double of velocity model parameters for b layers-
%                   Column:     Variable:
%                      1        depth of each layer
%                      2        p-wave velocity for each layer
%                      3        p-wave velocity gradient for each layer
%                      4        s-wave velocity for each layer
%                      5        s-wave velocity gradient for each layer
%                      6        density at the top of each layer
%                      7        density gradient for each layer



% extracting velocity model parameters 
layer_depth=velocity_model(:,1); % depth is positive down
p_velocity = velocity_model(:,2); % p-wave velocity for each layer
p_grad = velocity_model(:,3); % p-wave velocity gradient for each layer
s_velocity = velocity_model(:,4); % s-wave velocity for each layer
s_grad = velocity_model(:,5); % s-wave velocity gradient for each layer
rho_top = velocity_model(:,6);% density at the top of each layer
rho_grad=  velocity_model(:,7);% density gradient for each layer

% Creating and writing the Vel2Grid file in the required format 
filename='Vel2Grid_S.in';
fileID=fopen(filename,'w');

first_line = ['\nVGOUT  ./model/layer'];
second_line = ['\nVGTYPE S'];
third_line = ['\nVGGRID ' num2str(grid_num(1)) ' ' num2str(grid_num(2)) ' ' num2str(grid_num(3)) ' ' num2str(grid_origin(1)) ' ' num2str(grid_origin(2)) ' ' num2str(grid_origin(3)) ' ' num2str(grid_spacing(1)) ' ' num2str(grid_spacing(2)) ' ' num2str(grid_spacing(3)) ' ' 'SLOW_LEN'];

fprintf(fileID,first_line)
fprintf(fileID,second_line)
fprintf(fileID,third_line)



for i=1:length(layer_depth)
current_line = ['\nLAYER ' num2str(layer_depth(i)) ' ' num2str(p_velocity(i)) ' ' num2str(p_grad(i)) ' ' num2str(s_velocity(i)) ' ' num2str(s_grad(i)) ' ' num2str(rho_top(i)) ' ' num2str(rho_grad(i))];
fprintf(fileID,current_line)
end



fclose('all')
