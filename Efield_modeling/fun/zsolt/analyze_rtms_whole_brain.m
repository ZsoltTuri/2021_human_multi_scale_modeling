function analyze_rtms_whole_brain(var)
arguments
    var.participant
    var.mesh_path
    var.mesh_name
    var.out_path
    var.out_name
    var.mso 
end   
% -------------------------------------------------------------------------
% Read macroscopic EF simulation data  
% -------------------------------------------------------------------------
% idx, element: GM surface = 1002 & element tri; GM volume = 2 & element tet!
msh = mesh_load_gmsh4(fullfile(var.mesh_path, var.mesh_name));
msh_surf = mesh_extract_regions(msh, 'elemtype', 'tri', 'region_idx', 1002); 
msh_vol = mesh_extract_regions(msh, 'elemtype', 'tet', 'region_idx', 2);     
% -------------------------------------------------------------------------
% Analysis 
% -------------------------------------------------------------------------
% Absolute EF (GM surface)
field_idx = get_field_idx(msh_surf, 'normE', 'elements');
field = msh_surf.element_data{field_idx}.tridata;
field = field * var.mso; 
results(1, 1) = prctile(field, 99.9);
writematrix(results, fullfile(var.out_path, strcat(var.out_name, '_EFabs_GMsurf_whole_brain.xlsx'))); 

% Absolute EF (GM volume)
field_idx = get_field_idx(msh_vol, 'normE', 'elements');
field = msh_vol.element_data{field_idx}.tetdata;
field = field * var.mso; 
results(1, 1) = prctile(field, 99.9);
writematrix(results, fullfile(var.out_path, strcat(var.out_name, '_EFabs_GMvol_whole_brain.xlsx'))); 
end    