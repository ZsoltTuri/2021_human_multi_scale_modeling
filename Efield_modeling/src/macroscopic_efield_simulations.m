%% Info:
% Perform macroscopic E-field simulations. 

%% Initialize
clear
run(fullfile('', 'initialize.m'))
%% Set simulation parameters
coil_path = fullfile('', 'Simnibs_3.2.1', 'simnibs_env', 'Lib', 'site-packages', 'simnibs', 'ccd-files');
coil_magvent = 'MagVenture_MC_B70.ccd';
ccr = 1.49;                  % coil current rate of change at 1% mso; value is stimulator-specific!
mso = 1;                     % mso: maximum stimulator output
targets = {'dlpfc', 'prg'};
coil_fnames = load(fullfile(path, 'matsimnibs', 'coil_filenames.mat'));   
coil_fnames = coil_fnames.coil_fnames;
%% Run brute force grid simulations 
for t = 1:length(targets)
    target = targets{t};
    for p = 1:length(participants)
        participant = strcat('s', num2str(participants(p)));
        
        simulation_folder = fullfile(path, 'simulations_init', target, participant);
        if ~exist(simulation_folder, 'dir')
            mkdir(simulation_folder)
        end
        mesh_path = fullfile(path, 'meshes', participant);
        mesh_name = strcat(participant, '.msh');
               
        % run simulations
        parfor f = 1:length(coil_fnames)
            coildir_fname = coil_fnames{f, 1};
            coil_struct = load(fullfile(path, 'matsimnibs', target, participant, coildir_fname));
            coilparameters = coil_struct.coilparameters;
            out_path = fullfile(simulation_folder, coildir_fname(12:end-4));
            simulate_rtms( ...
                'participant', participant, 'mesh_path', mesh_path, 'mesh_name', mesh_name, 'out_path', out_path, 'ccr', ccr, 'mso', mso, ...
                'coil_file', coil_magvent, 'coil_path', coil_path, 'coilparameters', coilparameters);       
        end
    end
end