function run_multi_scale_modeling(var)
arguments
    var.workspace
    var.sim_folder
    var.sim
    var.participant_idx
    var.targets
    var.target
    var.cell_locations
    var.syn_weight_val
    var.mso_max
end
if strcmp(var.target, 'dlpfc')
    target_idx = 1;
elseif strcmp(var.target, 'prg')
    target_idx = 2;
else
    disp('unknown target')
end
workspace = var.workspace;
sim_folder = var.sim_folder;
sim = var.sim;
participant = var.participant_idx;
target = var.targets{target_idx};
cell_locations = var.cell_locations;
syn_weight_val = var.syn_weight_val;
mso_max = var.mso_max;
counter = load(strcat(workspace, filesep, sim_folder, filesep, 'Results', filesep, strcat('p', participant, '_', target, '_counter.mat')));
counter = cell2mat(struct2cell(counter));
nlocs = size(cell_locations{1, target_idx}, 1);
thresholds = zeros(nlocs, 2);
parfor L = 1:nlocs
    model_name = strcat('Aberra_human_L5_p', participant, '_', target, '_', sim, '_loc_', num2str(L));
    cd(strcat(workspace, filesep, sim_folder, filesep, 'Models', filesep, model_name, filesep, 'Code', filesep, 'NEURON'))
    params_file = 'params.txt';
    quasipotentials_file = strcat('quasipotentials_', target, '_loc_', num2str(L), '.txt');
    thresholds(L, :) = determine_activation_threshold('path', strcat(workspace, filesep, sim_folder), 'model_name', model_name, 'syn_weight', syn_weight_val, 'mso_max', mso_max, ...
                                                      'counter', counter(L, 1), 'params_file', params_file, 'quasipotentials_file', quasipotentials_file);
end
output_name = strcat('p', participant, '_', target, '_mso_threshold_', sim, '.mat');
output_path = strcat(workspace, filesep, sim_folder, filesep, 'Results', filesep);
save(strcat(output_path, output_name), 'thresholds');
end