function distance = get_scalp_cortex_distance(var)
arguments
    var.participant
    var.path
    var.coil_center
end

distance = zeros(length(var.target_gm), 1);
for d = 1:length(distance)
    distance(d, 1) = norm(var.coil_pos{d, 1}(1:3, 4)' - var.target_gm(d, :)); 
    distance(d, 1) = distance(d, 1) - 4;
end
output = fullfile(var.path.main, var.path.simnibs_results, [var.sim_folder, '_', var.res_folder], ['sub_', var.participant, '_scalp_cortex_distance.csv']);
writematrix(distance, output);
end