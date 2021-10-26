%% Info:
% Macroscopic E-field analysis in the respective ROI from the E-field
% optimized simulations.

%% Initialize
clear
run(fullfile('', 'initialize.m'))

%% ROI analysis (+add EF components to the cropped mesh)
radius = 10;
targets = {'dlpfc', 'prg'};
coil_fnames = load(fullfile(path, 'matsimnibs', 'coil_filenames.mat'));   
coil_fnames = coil_fnames.coil_fnames;
coil_fnames = coil_fnames(49:60, 1);

for t = 1:length(targets)
    target = targets{t};
    for p = 1:length(participants)
        participant = strcat('s', num2str(participants(p)));
        % output folder     
        analysis_folder = fullfile(path, strcat('simulations_macro_analysis_', num2str(radius), 'mmROI_efield_opt'), target, participant);
        if ~exist(analysis_folder, 'dir')
            mkdir(analysis_folder)
        end               
        parfor k = 1:length(coil_fnames)
           % select the coil parameter
            coildir_fname = coil_fnames{k, 1};
            coil_struct = load(fullfile(path, 'matsimnibs', target, participant, coildir_fname));
            coilparameters = coil_struct.coilparameters;
            coil_center = coilparameters(1:3, 4)';
            % select mesh file and intensity
            sim = coildir_fname(12:(end-4));
            mesh_path = fullfile(path, 'simulations_macro_cropped', target, participant);
            mesh_name = strcat(participant, '_', sim, '_cropped.msh');
            mso = load(fullfile(path, 'intensities', strcat('Efield_', num2str(radius), '_mm_ROI'), target, participant, strcat(participant, '_', sim, '_EFabs_GMsurf_opt.mat')));
            mso = cell2mat(struct2cell(mso));
            out_mesh_name = strcat(participant, '_', sim, '_cropped_EFcomps.msh');
            out_name = strcat(participant, '_', sim);
            out_path = analysis_folder;
            analyze_rtms('participant', participant, 'mesh_path', mesh_path, 'mesh_name', mesh_name, 'out_path', out_path, 'out_name', out_name, ...
                         'coil_center', coil_center, 'mso', mso, 'radius', radius); 
        end
    end
end