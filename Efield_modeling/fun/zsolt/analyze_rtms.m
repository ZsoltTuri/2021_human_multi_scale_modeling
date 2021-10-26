function analyze_rtms(var)
arguments
    var.participant
    var.mesh_path
    var.mesh_name
    var.out_path
    var.out_name
    var.coil_center
    var.mso % simulation was run at 1% MSO, hence, we need to scale it with the preferred intensity. 
    var.radius
end   
% -------------------------------------------------------------------------
% Read macroscopic EF simulation data  
% -------------------------------------------------------------------------
% idx, element: GM surface = 1002 & element tri; GM volume = 2 & element tet!
msh = mesh_load_gmsh4(fullfile(var.mesh_path, var.mesh_name));
msh = mesh_append_normal_and_tangential_efield_simnibs21(msh);
mesh_save_gmsh4(msh, fullfile(var.mesh_path, strcat(var.mesh_name, '_EFcomps.msh')));
msh_surf = mesh_extract_regions(msh, 'elemtype', 'tri', 'region_idx', 1002); 
msh_vol = mesh_extract_regions(msh, 'elemtype', 'tet', 'region_idx', 2);     
surf_centers = mesh_get_triangle_centers(msh_surf);
vol_centers = mesh_get_tetrahedron_centers(msh_vol);
idx = mesh_get_closest_triangle_from_point2(msh_surf, var.coil_center, 1002);
gray_matter_roi_center = surf_centers(idx, :);
% -------------------------------------------------------------------------
% Analysis 
% -------------------------------------------------------------------------
% Absolute EF (GM surface)
field_idx = get_field_idx(msh_surf, 'normE', 'elements');
field = msh_surf.element_data{field_idx}.tridata;
field = field * var.mso; 
roi = get_spherical_roi(surf_centers, gray_matter_roi_center, var.radius);
[results, results_raw] = get_efield_statistics_in_roi(field, roi);
save(fullfile(var.out_path, strcat(var.out_name, '_EFabs_GMsurf_stat.mat')), 'results'); 
% writematrix(results_raw, fullfile(var.out_path, strcat(var.out_name, '_EFabs_GMsurf_raw.csv')));

% Absolute EF (GM volume)
field_idx = get_field_idx(msh_vol, 'normE', 'elements');
field = msh_vol.element_data{field_idx}.tetdata;
field = field * var.mso; 
roi = get_spherical_roi(vol_centers, gray_matter_roi_center, var.radius);
[results, results_raw] = get_efield_statistics_in_roi(field, roi);
save(fullfile(var.out_path, strcat(var.out_name, '_EFabs_GMvol_stat.mat')), 'results'); 
% writematrix(results_raw, fullfile(var.out_path, strcat(var.out_name, '_EFabs_GMvol_raw.csv'))); 

% Tangential EF component (GM surface)
field_idx = get_field_idx(msh_surf, 'E_tan_norm', 'elements');
field = msh_surf.element_data{field_idx}.tridata;
field = field * var.mso; 
roi = get_spherical_roi(surf_centers, gray_matter_roi_center, var.radius);
[results, results_raw] = get_efield_statistics_in_roi(field, roi);
save(fullfile(var.out_path, strcat(var.out_name, '_EFtan_GMsurf_stat.mat')), 'results'); 
% writematrix(results_raw, fullfile(var.out_path, strcat(var.out_name, '_EFtan_GMsurf_raw.csv'))); 

% Perpendicular EF component (GM surface)
field_idx = get_field_idx(msh_surf, 'E_perp_norm', 'elements');
field = msh_surf.element_data{field_idx}.tridata;
field = field * var.mso; 
roi = get_spherical_roi(surf_centers, gray_matter_roi_center, var.radius);
[results, results_raw] = get_efield_statistics_in_roi(field, roi);
save(fullfile(var.out_path, strcat(var.out_name, '_EFperp_GMsurf_stat.mat')), 'results');  
% writematrix(results_raw, fullfile(var.out_path, strcat(var.out_name, '_EFperp_GMsurf_raw.csv'))); 

% Perpendicular EF component direction specific (GM surface) 
field_idx = get_field_idx(msh_surf, 'E_perp_dir_norm', 'elements');
field = msh_surf.element_data{field_idx}.tridata;
field = field * var.mso; 
roi = get_spherical_roi(surf_centers, gray_matter_roi_center, var.radius);
[results_pos, results_neg, results_raw_pos, results_raw_neg] = get_efield_statistics_for_normal_EF_component_in_roi(field, roi);
save(fullfile(var.out_path, strcat(var.out_name, '_EFperppos_GMsurf_stat.mat')), 'results_pos');
save(fullfile(var.out_path, strcat(var.out_name, '_EFperpneg_GMsurf_stat.mat')), 'results_neg');
% writematrix(results_raw_pos, fullfile(var.out_path, strcat(var.out_name, '_EFperppos_GMsurf_raw.csv')));
% writematrix(results_raw_neg, fullfile(var.out_path, strcat(var.out_name, '_EFperpneg_GMsurf_raw.csv'))); 
end    