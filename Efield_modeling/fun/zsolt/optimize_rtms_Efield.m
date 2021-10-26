function optimize_rtms_Efield(var)
arguments
    var.participant
    var.mesh_path
    var.mesh_name
    var.out_path
    var.out_name
    var.coil_center
    var.mso % simulation was run at 1% MSO, hence, we need to scale it with the preferred intensity. 
    var.radius
    var.efield
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
% Absolute EF (GM surface)
% -------------------------------------------------------------------------
mean_col = 3;
field_idx = get_field_idx(msh_surf, 'normE', 'elements');
field = msh_surf.element_data{field_idx}.tridata;
field = field * var.mso; 
roi = get_spherical_roi(surf_centers, gray_matter_roi_center, var.radius);
[results, results_raw] = get_efield_statistics_in_roi(field, roi);
opt = round(var.efield / results(1, mean_col));
save(fullfile(var.out_path, strcat(var.out_name, '_EFabs_GMsurf_opt.mat')), 'opt'); 

end    