%% Info:
% Crop E-field mesh. 

%% Initialize
clear
run(fullfile('', 'initialize.m'))

%% Crop and save EF mesh for later analysis
radius = 50;
targets = {'dlpfc', 'prg'};
coil_fnames = load(fullfile(path, 'matsimnibs', 'coil_filenames.mat'));   
coil_fnames = coil_fnames.coil_fnames;

for t = 1:length(targets)
    target = targets{t};
    for p = 1:length(participants)
        participant = strcat('s', num2str(participants(p)));
        mesh_name = strcat(participant, '_TMS_1-0001_MagVenture_MC_B70_scalar.msh');
        % output folder
        crop_path = fullfile(path, 'simulations_macro_cropped', target, participant);
        if ~exist(crop_path, 'dir')
            mkdir(crop_path)
        end              
        parfor k = 1:length(coil_fnames)
            % select the coil parameter
            coildir_fname = coil_fnames{k, 1};
            coil_struct = load(fullfile(path, 'matsimnibs', target, participant, coildir_fname));
            coilparameters = coil_struct.coilparameters;
            coil_center = coilparameters(1:3, 4)';
            % select mesh file
            sim = coildir_fname(12:(end-4));
            mesh_path = fullfile(path, 'simulations_init', target, participant, sim);
            out_mesh_name = strcat(participant, '_', sim, '_cropped.msh');
            crop_and_save_mesh('participant', participant, 'mesh_path', mesh_path, 'mesh_name', mesh_name, ...
                               'coil_center', coil_center, 'radius', radius, 'out_mesh_path', crop_path, 'out_mesh_name', out_mesh_name);
        end
    end
end