function crop_and_save_mesh(var)
arguments
    var.participant
    var.mesh_path
    var.mesh_name
    var.coil_center
    var.radius
    var.out_mesh_path
    var.out_mesh_name
end
msh = mesh_load_gmsh4(fullfile(var.mesh_path, var.mesh_name));
dist = get_distance(msh.nodes, var.coil_center);
nodes_idx = dist < var.radius;
msh_crop = mesh_extract_points(msh, nodes_idx);
mesh_save_gmsh4(msh_crop, fullfile(var.out_mesh_path, var.out_mesh_name));
end