%% Info:
% Generate neuronal models. 

%% Set preliminaires
workspace_path = strcat(filesep, 'pfs', filesep, 'work7', filesep, 'workspace', filesep, 'scratch', filesep, 'fr_zt1001-MSM-0');
repository = '2021_human_msm';
sim_folder = 'sim_msm';
workspace = strcat(workspace_path, filesep, repository);
addpath(genpath(strcat(workspace, filesep, 'fun', filesep))); 
run(strcat(workspace, filesep, sim_folder, filesep, 'Model_Generation', filesep, 'lib', filesep, 'init_t2n_trees.m'));
model_name = 'Aberra_human_L5';
participants = [1:16]';
targets = {'dlpfc', 'prg'}';

%% Model generation
cd(strcat(workspace, filesep, sim_folder, filesep, 'Model_Generation', filesep))
Aberra_L5_model()
cd(strcat(workspace, filesep, sim_folder, filesep, 'Models', filesep, model_name, filesep, 'Code', filesep, 'NEURON'))
system('nrniv save_locations.hoc')

%% Copy neuronal model folders 
source_folder = [workspace filesep sim_folder filesep 'Models' filesep model_name filesep];
sim = 'syn';
target_folder = [workspace filesep sim_folder filesep 'Models' filesep strcat(model_name, '_', sim) filesep];
if not(isfolder(target_folder))
    mkdir(target_folder)
end
status = copyfile(source_folder, target_folder, 'f');
if status == 1
    disp('Copying source folder successfully!');
else
    disp('Error copying source folder!');
end

sims = {'spTMS', 'spTMS_syn'}';
for s = 1:size(sims, 1)
    sim = sims{s, 1};
    for p = 1:size(participants, 1)  
        for t = 1:size(targets, 1)
            target = targets{t, 1};
            target_folder = [workspace filesep sim_folder filesep 'Models' filesep strcat(model_name, '_p', num2str(p), '_', target, '_', sim) filesep];
            if not(isfolder(target_folder))
                mkdir(target_folder)
            end
            status = copyfile(source_folder, target_folder, 'f');
            if status == 1
                disp('Copying source folder successfully!');
            else
                disp('Error copying source folder!');
            end
        end
    end
end
   
%% Copy TMS waveform folders
sim = 'syn';
source_folder = [workspace filesep 'src' filesep 'adjusted_nemo_codes' filesep sim filesep 'TMS_Waveform' filesep];
target_folder = [workspace filesep sim_folder filesep 'Models' filesep strcat(model_name, '_', sim) filesep 'Results' filesep 'TMS_Waveform' filesep];
if not(isfolder(target_folder))
    mkdir(target_folder)
end
status = copyfile(source_folder, target_folder, 'f');
if status == 1
    disp('Copying TMS waveforms successfully!');
else
    disp('Error copying TMS waveforms!');
end

sims = {'spTMS', 'spTMS_syn'}';
for s = 1:size(sims, 1)
    sim = sims{s, 1};
    source_folder = [workspace filesep 'src' filesep 'adjusted_nemo_codes' filesep sim filesep 'TMS_Waveform' filesep];
    for p = 1:size(participants, 1)  
        for t = 1:size(targets, 1)
            target = targets{t, 1};
            target_folder = [workspace filesep sim_folder filesep 'Models' filesep strcat(model_name, '_p', num2str(p), '_', target, '_', sim) filesep 'Results' filesep 'TMS_Waveform' filesep];
            if not(isfolder(target_folder))
                mkdir(target_folder)
            end
            status = copyfile(source_folder, target_folder, 'f');
            if status == 1
                disp('Copying TMS waveforms successfully!');
            else
                disp('Error copying TMS waveforms!');
            end
        end
    end
end
%% Copy hoc files
sim = 'syn';
source_folder = [workspace filesep 'src' filesep 'adjusted_nemo_codes' filesep sim filesep 'hoc_codes' filesep];
target_folder = [workspace filesep sim_folder filesep 'Models' filesep strcat(model_name, '_', sim) filesep 'Code' filesep 'NEURON' filesep];
status = copyfile(source_folder, target_folder, 'f');
if status == 1
    disp('Copying hoc files successfully!');
else
    disp('Error copying hoc files!');
end
    
sims = {'spTMS', 'spTMS_syn'}';
for s = 1:size(sims, 1)
    sim = sims{s, 1};
    source_folder = [workspace filesep 'src' filesep 'adjusted_nemo_codes' filesep sim filesep 'hoc_codes' filesep];
    for p = 1:size(participants, 1)  
        for t = 1:size(targets, 1)
            target = targets{t, 1};
            target_folder = [workspace filesep sim_folder filesep 'Models' filesep strcat(model_name, '_p', num2str(p), '_', target, '_', sim) filesep 'Code' filesep 'NEURON' filesep];
            status = copyfile(source_folder, target_folder, 'f');
            if status == 1
                disp('Copying hoc files successfully!');
            else
                disp('Error copying hoc files!');
            end
        end
    end
end
%% Copy couple script
% folder: MSO threshold estimation using spTMS
sims = {'spTMS', 'spTMS_syn'}';
for s = 1:size(sims, 1)
    sim = sims{s, 1};
    source_folder = [workspace filesep 'src' filesep 'adjusted_nemo_codes' filesep sim filesep 'couple_script' filesep];
    for p = 1:size(participants, 1)  
        for t = 1:size(targets, 1)
            target = targets{t, 1};
            target_folder = [workspace filesep sim_folder filesep 'Models' filesep strcat(model_name, '_p', num2str(p), '_', target, '_', sim) filesep 'Code' filesep 'E-Field_Coupling' filesep];
            status = copyfile(source_folder, target_folder, 'f');
            if status == 1
                disp('Copying coupling script successfully!');
            else
                disp('Error copying coupling script!');
            end
        end
    end
end

%% Create folders for threshold estimation
sim = 'syn';
folder_name = [workspace filesep sim_folder filesep 'Models' filesep strcat(model_name, '_', sim) filesep 'Results' filesep 'thresholds' filesep];
create_folder('folder_name', folder_name);
sims = {'spTMS', 'spTMS_syn'}';
for s = 1:size(sims, 1)
    sim = sims{s, 1};
    for p = 1:size(participants, 1)  
        for t = 1:size(targets, 1)
            target = targets{t, 1};
            folder_name = [workspace filesep sim_folder filesep 'Models' filesep strcat(model_name, '_p', num2str(p), '_', target, '_', sim) filesep 'Results' filesep 'thresholds' filesep];
            create_folder('folder_name', folder_name);
            disp(['Created threshold folder for participant ' num2str(p)]);
        end
    end
end   
