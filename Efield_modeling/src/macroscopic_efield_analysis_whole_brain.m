%% Info:
% Macroscopic E-field analysis in the whole brain

%% Initialize
clear
run(fullfile('', 'initialize.m'))

%% ROI analysis (+add EF components to the cropped mesh)
mso = repmat(1, 1, length(participants));
target = 'prg';
coil_fnames = load(fullfile(path, 'matsimnibs', 'coil_filenames.mat'));   
coil_fnames = coil_fnames.coil_fnames;
coil_fnames = coil_fnames(49:60, 1);

for p = 1:length(participants)
    participant = strcat('s', num2str(participants(p)));
    % output folder     
    analysis_folder = fullfile(path, strcat('simulations_macro_analysis_max'), participant);
    if ~exist(analysis_folder, 'dir')
        mkdir(analysis_folder)
    end               
    parfor k = 1:length(coil_fnames)
        sim_folder = coil_fnames{k, 1}(12:(end-4));
        mesh_path = fullfile(path, 'simulations_init', target, participant, sim_folder);
        mesh_name = strcat(participant, '_TMS_1-0001_MagVenture_MC_B70_scalar.msh');
        out_name = strcat(participant, '_', sim_folder);
        out_path = analysis_folder;
        analyze_rtms_whole_brain('participant', participant, 'mesh_path', mesh_path, 'mesh_name', mesh_name, 'out_path', out_path, 'out_name', out_name, 'mso', mso(p)); 
    end
end