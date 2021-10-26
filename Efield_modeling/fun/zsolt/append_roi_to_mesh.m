function [msh_surf, gray_matter_roi_center] = append_roi_to_mesh(var)
arguments
    var.mesh_path
    var.mesh_name
    var.initial_coordinate
    var.radius
end
% -------------------------------------------------------------------------
% Read macroscopic EF simulation data  
% -------------------------------------------------------------------------
% idx, element: GM surface = 1002 & element tri!
file = fullfile(var.mesh_path, var.mesh_name);
msh = mesh_load_gmsh4(file);
msh_surf = mesh_extract_regions(msh, 'elemtype', 'tri', 'region_idx', 1002); 
surf_centers = mesh_get_triangle_centers(msh_surf);
% get gray matter surface point closest to the initial coordiante 
idx = mesh_get_closest_triangle_from_point2(msh_surf, var.initial_coordinate, 1002);
gray_matter_roi_center = surf_centers(idx, :);

%--------------------------------------------------------------------------
% Append roi to mesh
%--------------------------------------------------------------------------
msh_surf.element_data{1, 1} = struct();
msh_surf.element_data{1, 1}.name = 'roi_surface';
msh_surf.element_data{1, 1}.tridata(1:length(msh_surf.triangles), 1) = 0;
msh_surf.element_data{1, 1}.tetdata = [];
roi = get_spherical_roi(surf_centers, gray_matter_roi_center, var.radius);
msh_surf.element_data{1, 1}.tridata(roi, 1) = 1;
end