function voltage_modeling(var)
arguments
    var.workspace
    var.sim_folder
    var.sim
    var.participant
    var.target
    var.mso
    var.cell_idx
end

model_name = strcat('Aberra_human_L5_p', var.participant, '_', var.target, '_', var.sim, '_loc_', var.cell_idx);
cd(strcat(var.workspace, filesep, var.sim_folder, filesep, 'Models', filesep, model_name, filesep, 'Code', filesep, 'NEURON', filesep))
params_path = strcat(var.workspace, filesep, var.sim_folder, filesep, 'Models', filesep, model_name, filesep, 'Results', filesep, 'NEURON');
params_file = 'params.txt';
tms_amp = var.mso;
syn_freq = '3.000000';
syn_noise = '0.500000';
syn_weight = '0.000000';
syn_weight_sync = '0.000000'; 
tms_offset = '2.000000';   
quasipotentials_file = strcat('quasipotentials_', var.target, '_loc_', var.cell_idx, '.txt');
create_paramstxt_file('params_path', params_path, 'params_file', params_file, ...
                      'tms_amp', tms_amp, 'syn_freq', syn_freq, 'syn_noise', syn_noise, ...
                      'syn_weight', syn_weight, 'syn_weight_sync', syn_weight_sync, 'tms_offset', tms_offset, 'quasipotentials_file', quasipotentials_file)
cd(strcat(var.workspace, filesep, var.sim_folder, filesep, 'Models', filesep, model_name, filesep, 'Code', filesep, 'NEURON', filesep))
system('nrniv -nogui TMS_script.hoc');