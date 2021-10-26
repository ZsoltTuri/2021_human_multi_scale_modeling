
function prepare_coilparameters(var)
arguments
    var.participant
    var.mesh_path
    var.mesh_name
    var.out_path_coil
    var.out_path_gmsh
    var.center
    var.grid_x_points
    var.grid_y_points
    var.grid_spatial_resolution
    var.grid_angle_resolution
    var.coil_skin_distance
end

% ------------------------------------------------------------------------- 
% Preliminaries
% ------------------------------------------------------------------------- 
npoints = var.grid_x_points * var.grid_y_points;
coil_angle_deg = 0:var.grid_angle_resolution:(360 - var.grid_angle_resolution);
coil_angle_rad = deg2rad(coil_angle_deg);
% setting up direction vectors for different coordinate spaces
gridx = [1 0 0];    % grid coordinate space: choose direction for grid x axis ([1 0 0] for straight grid)
gridz = [0 0 1];    % grid coordinate space: choose direction for grid z axis (typically [0 0 1])
coilz = [0 0 1];    % coil coordinate space: choose coil z axis (typically [0 0 1])
headz = [0 0 1];    % head coordinate space: choose head z axis (will be [0 0 1] for meshes created with headreco)

% ------------------------------------------------------------------------- 
% Mesh 
% ------------------------------------------------------------------------- 
msh = mesh_load_gmsh4(fullfile(var.mesh_path, var.mesh_name));
% get skin and gray matter surfaces from mesh
msh_skin_surface = mesh_extract_regions(msh, 'elemtype', 'tri', 'region_idx', 1005);
msh_gm_surface = mesh_extract_regions(msh, 'elemtype', 'tri', 'region_idx', 1002);
% get surface center points and normal vectors for skin and gray matter
surface_skin_centers = mesh_get_triangle_centers(msh_skin_surface);
surface_skin_normals = mesh_get_triangle_normals(msh_skin_surface);
surface_gm_centers = mesh_get_triangle_centers(msh_gm_surface);   
% get skin point closest to the roi center coordiante
idx = mesh_get_closest_triangle_from_point2(msh_skin_surface, var.center, 1005);
centerpoint_skin = surface_skin_centers(idx, :);
centernormal_skin = surface_skin_normals(idx, :);

% -------------------------------------------------------------------------    
% Rotate grid axis based on center point normal vector     
% ------------------------------------------------------------------------- 
% get angle between grid z and centernormal (both vectors are normalized)
theta = acos(gridz * centernormal_skin'); 
% get rotation axis (normalized)
axis_rot = cross(gridz, centernormal_skin)/norm(cross(gridz, centernormal_skin));
% get skew symmetric representation of the normalized axis
axis_skewed = [0 -axis_rot(3) axis_rot(2); axis_rot(3) 0 -axis_rot(1); -axis_rot(2) axis_rot(1) 0];
% Rodrigues' formula for the rotation matrix
R = eye(3) + sin(theta)*axis_skewed + (1-cos(theta))*axis_skewed^2;
% update grid X and Y axis
gridx_new = (R * gridx')';
gridy_new = cross(centernormal_skin, gridx_new);

% -------------------------------------------------------------------------
% Get grid positions and coil z vectors
% ------------------------------------------------------------------------- 
% calculate x by y grid around a center point on the scalp
points = zeros(var.grid_x_points, var.grid_y_points, 3); % initialize matrix for coordinates
zvectors = zeros(var.grid_x_points, var.grid_y_points, 3); % initialize matrix for coil zvectors
% loop through grid using spacing indexing
for i = -floor(var.grid_x_points/2):ceil(var.grid_x_points/2)-1
    for j = -floor(var.grid_y_points/2):ceil(var.grid_y_points/2)-1
        idx = mesh_get_closest_triangle_from_point2(msh_skin_surface,(centerpoint_skin + var.grid_spatial_resolution*i * gridx_new + var.grid_spatial_resolution*j * gridy_new));
        points(i+floor(var.grid_x_points/2)+1,j+floor(var.grid_y_points/2)+1,:) = surface_skin_centers(idx, :);
        zvectors(i+floor(var.grid_x_points/2)+1,j+floor(var.grid_y_points/2)+1,:) = surface_skin_normals(idx, :);
    end
end
% rearrange grid positions ([x1,y1,z1;x2,y2,z2;...])
grid = reshape(points, var.grid_x_points * var.grid_y_points, 3);
zvectors = reshape(zvectors, var.grid_x_points * var.grid_y_points, 3);

% -------------------------------------------------------------------------
% Prepare and save affine transformation matrix
% ------------------------------------------------------------------------- 
% project headz onto coil xy-plane (zvector is normal to this plane)
coily = repmat(headz, length(zvectors), 1) - (dot(repmat(headz, length(zvectors),1), zvectors, 2)./dot(zvectors,zvectors,2)).*zvectors;
yvectors = zeros(size(coily));
% get coil y and x vectors 
for a = 1:length(coil_angle_rad)
    angle = coil_angle_rad(a);
    angle_str = num2str(rad2deg(angle));
%     for i = 1:length(coily)
%         axis_rot = cross(zvectors(i, :), coily(i, :))/norm(cross(zvectors(i, :), coily(i, :)));
%         axis_skewed = [0 -axis_rot(3) axis_rot(2); axis_rot(3) 0 -axis_rot(1); -axis_rot(2) axis_rot(1) 0];
%         R = eye(3) + sin(angle)*axis_skewed + (1-cos(angle))*axis_skewed^2;
%         yvectors(i, :) = (R * coily(i, :)')';
%     end
    for i = 1:length(coily)
        ux = zvectors(i, 1);
        uy = zvectors(i, 2);
        uz = zvectors(i, 3);
        R = [cos(angle)+ux^2*(1-cos(angle)), ux*uy*(1-cos(angle))-uz*sin(angle), ux*uz*(1-cos(angle))+uy*sin(angle);...
            uy*ux*(1-cos(angle))+uz*sin(angle), cos(angle)+uy^2*(1-cos(angle)), uy*uz*(1-cos(angle))-ux*sin(angle);...
            uz*ux*(1-cos(angle))-uy*sin(angle), uz*uy*(1-cos(angle))+ux*sin(angle), cos(angle)+uz^2*(1-cos(angle))];
        yvectors(i,:) = (R*coily(i,:)')';
    end
    
    % normalize coil vectors
    yvectors = bsxfun(@rdivide, yvectors, normd(yvectors));
    xvectors = cross(zvectors, yvectors);
    xvectors = bsxfun(@rdivide, xvectors, normd(xvectors));
    % prepare affine transformation matrix for the coil (a.k.a 'matsimnibs')
    for p = 1:npoints
        coilparameters = cat(2,[xvectors(p,:)'; 0],[yvectors(p,:)'; 0],[-zvectors(p,:)'; 0],[grid(p,:)' + (var.coil_skin_distance * zvectors(p,:))'; 1]);
        fname = strcat('matsimnibs', '_pos_', num2str(p), '_angle_', angle_str, '.mat'); 
        save(fullfile(var.out_path_coil, fname), 'coilparameters');
        % write coil parameters for Gmsh visualization
        write_coilorientation_in_mesh(zvectors, grid, fullfile(var.out_path_gmsh, strcat('pos_', num2str(p), '_angle_', angle_str, '_grid_z.geo')));
        write_coilorientation_in_mesh(xvectors, grid, fullfile(var.out_path_gmsh, strcat('pos_', num2str(p), '_angle_', angle_str, '_grid_x.geo')));
        write_coilorientation_in_mesh(yvectors, grid, fullfile(var.out_path_gmsh, strcat('pos_', num2str(p), '_angle_', angle_str, '_grid_y.geo')));
        write_pointvalues_in_geofile(grid, 1:npoints, fullfile(var.out_path_gmsh, strcat('pos_', num2str(p), '_angle_', angle_str, '_pos_nums.geo')));  
    end    
end
