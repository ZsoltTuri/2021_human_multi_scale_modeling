function prepare_folders(var)
arguments
    var.workspace
    var.sim_folder
    var.participant_idx
    var.targets
    var.target
    var.sim
    var.cell_locations
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
participant = var.participant_idx;
target = var.targets{target_idx};
sim = var.sim;
cell_locations = var.cell_locations;
model_name = strcat('Aberra_human_L5_p', participant, '_', target, '_', sim);
source_folder = strcat(workspace, filesep, sim_folder, filesep, 'Models', filesep, model_name);
source_sub_folders = {strcat('Code', filesep, 'NEURON'), 'lib_custom', 'lib_genroutines', 'lib_mech', 'morphos', ...
                      strcat('Results', filesep, 'E-field_Coupling'), strcat('Results', filesep, 'NEURON'), strcat('Results', filesep, 'thresholds'), strcat('Results', filesep, 'TMS_Waveform')}';
nlocs = size(cell_locations{1, target_idx}, 1);
parfor L = 1:nlocs
    target_folder = strcat(source_folder, '_loc_', num2str(L));
    for ii = 1:size(source_sub_folders, 1)
        sub_folder = source_sub_folders{ii, 1};
        if strcmp(sub_folder, strcat('Results', filesep, 'E-field_Coupling'))
            mkdir(strcat(target_folder, filesep, 'Results', filesep, 'E-field_Coupling', filesep))
            file = strcat('parameters_', target, '_loc_', num2str(L), '.txt');
            copyfile(strcat(source_folder, filesep, sub_folder, filesep, file), strcat(target_folder, filesep, sub_folder, filesep, file), 'f');
            file = strcat('quasipotentials_', target, '_loc_', num2str(L), '.txt');
            copyfile(strcat(source_folder, filesep, sub_folder, filesep, file), strcat(target_folder, filesep, sub_folder, filesep, file), 'f');
        else
            copyfile(strcat(source_folder, filesep, sub_folder), strcat(target_folder, filesep, sub_folder), 'f');
        end
    end
end
end