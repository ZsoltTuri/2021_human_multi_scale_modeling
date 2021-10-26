% Estimate the action potential threshold for a synaptic input. 

%% Set preliminaires
workspace_path = [filesep 'pfs' filesep 'work7' filesep 'workspace' filesep 'scratch' filesep 'fr_zt1001-MSM-0'];
repository = '2021_human_msm';
sim_folder = 'sim_msm';
workspace = [workspace_path filesep repository];
addpath(genpath([workspace filesep 'fun' filesep])); 
run([workspace filesep sim_folder filesep 'Model_Generation' filesep 'lib' filesep 'init_t2n_trees.m']);

%% Load parameters
model_name = 'Aberra_human_L5_syn';
mso = num2str(0); % maximum stimulator output (if MSO is zero, cell position will not affect the synaptic weight threshold)
syn_weight_max = 0.2000000; % max synaptic weight

%% Estimate action potential threshold
% prepare params.txt files 
cd([workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Code' filesep 'NEURON'])
params_path = [workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Results' filesep 'NEURON'];
params_file = 'params.txt';
tms_amp = mso;
syn_freq = '3.000000';
syn_noise = '0.500000';
syn_weight = '0.000000'; 
syn_weight_sync = num2str(syn_weight_max); 
tms_offset = '2.000000';    
create_paramstxt_file('params_path', params_path, 'params_file', params_file, ...
                      'tms_amp', tms_amp, 'syn_freq', syn_freq, 'syn_noise', syn_noise, ...
                      'syn_weight', syn_weight, 'syn_weight_sync', syn_weight_sync, 'tms_offset', tms_offset)
% E-field coupling to neuronal model 
folder_name = [workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Results' filesep 'E-field_Coupling'];
create_folder('folder_name', folder_name)
meshfile = 'p1_pos_5_angle_45_cropped.msh';
meshpath = [workspace filesep 'data' filesep 'efm' filesep 'prg' filesep 'p1' filesep];
nrnloc = [-38.4652403333333, -16.0132153333333, 55.9324643333333];   
nrndpth = 1.25;
nrnfile = 'locs_all_seg.txt';
nrnpath = ['..' filesep '..' filesep 'Results' filesep 'NEURON' filesep 'locs' filesep]; 
nrnaxs = [0  1  0];
nrnori = []; 
scale_E = 1;
respath = ['..' filesep '..' filesep 'Results' filesep 'E-field_Coupling'];
parameters_file = 'parameters.txt';
create_parameter_file('meshfile', meshfile, 'meshpath', meshpath, 'nrnloc', nrnloc, 'nrndpth', nrndpth, 'nrnfile', nrnfile, 'nrnpath', nrnpath, 'nrnaxs', nrnaxs, ...
                      'nrnori', nrnori, 'scale_E', scale_E, 'respath', respath, 'parameters_file', parameters_file);
cd([workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Code' filesep 'E-Field_Coupling'])
couple_script([workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Results' filesep 'E-field_Coupling' filesep 'parameters.txt'])
% estimate the firing threshold by iteratively updating the params.txt file   
[threshold, ~] = determine_synaptic_weight('path', [workspace filesep sim_folder], 'model_name', model_name, 'syn_weight_max', syn_weight_max, 'mso', mso); 
save([workspace filesep 'data' filesep 'synaptic_weight_1_threshold.mat'], 'threshold');
