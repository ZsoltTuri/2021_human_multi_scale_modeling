function prepare_folders_forloop(var)
arguments
    var.workspace
    var.sim_folder
    var.participant_idx
    var.target
    var.sim
    var.cell_idx
end
workspace = var.workspace;
sim_folder = var.sim_folder;
participant = var.participant_idx;
target = var.target;
sim = var.sim;
model_name = strcat('Aberra_human_L5_p', participant, '_', target, '_', sim);
source_folder = strcat(workspace, filesep, sim_folder, filesep, 'Models', filesep, model_name);
source_sub_folders = {strcat('Code', filesep, 'NEURON'), strcat('Code', filesep, 'Calcium'), 'lib_custom', 'lib_genroutines', 'lib_mech', 'morphos', ...
                      strcat('Results', filesep, 'E-field_Coupling'), strcat('Results', filesep, 'NEURON'), strcat('Results', filesep, 'thresholds'), strcat('Results', filesep, 'TMS_Waveform')}';
target_folder = strcat(source_folder, '_loc_', var.cell_idx);
for ii = 1:size(source_sub_folders, 1)
    sub_folder = source_sub_folders{ii, 1};
    if strcmp(sub_folder, strcat('Results', filesep, 'E-field_Coupling'))
        mkdir(strcat(target_folder, filesep, 'Results', filesep, 'E-field_Coupling', filesep))
        file = strcat('parameters_', target, '_loc_',  var.cell_idx, '.txt');
        copyfile(strcat(source_folder, filesep, sub_folder, filesep, file), strcat(target_folder, filesep, sub_folder, filesep, file), 'f');
        file = strcat('quasipotentials_', target, '_loc_',  var.cell_idx, '.txt');
        copyfile(strcat(source_folder, filesep, sub_folder, filesep, file), strcat(target_folder, filesep, sub_folder, filesep, file), 'f');
    else
        copyfile(strcat(source_folder, filesep, sub_folder), strcat(target_folder, filesep, sub_folder), 'f');
    end
end
end
