function analyze_rTMS(idx)
% Analyze voltage and calcium modeling data.

%% Set preliminaires
workspace_path = strcat(filesep, 'pfs', filesep, 'work7', filesep, 'workspace', filesep, 'scratch', filesep, 'fr_zt1001-MSM-0');
repository = '2021_human_msm';
sim_folder = 'sim_msm';
workspace = strcat(workspace_path, filesep, repository);
addpath(genpath(strcat(workspace, filesep, 'fun', filesep))); 
run(strcat(workspace, filesep, sim_folder, filesep, 'Model_Generation', filesep, 'lib', filesep, 'init_t2n_trees.m'));

%% Set parameters
participant = num2str(idx);
sim = 'rTMS';
target = 'dlpfc';
cell_idx = 10944; %10944 2868 2291; % Set cell idx manually!
model_name = strcat('Aberra_human_L5_p', participant, '_', target, '_', sim, '_loc_', num2str(cell_idx));
swc = load(strcat(workspace, filesep, sim_folder, filesep, 'Models', filesep, model_name, filesep, 'Results', filesep, 'Calcium', filesep, 'neuron_out.swc'));
swc(:,3:5) = swc(:,3:5) * 1e6; % convert to um 
compartments = {'soma', 'axon', 'basal', 'apical'}'; % soma = 1; axon = 2; basal = 3; apical = 4;

%% Voltage data 
path = strcat(workspace, filesep, sim_folder, filesep, 'Models', filesep, model_name, filesep, 'Results', filesep, 'NEURON', filesep);          
data = readmatrix(strcat(path, filesep, 'voltage_trace.dat'))'; 
tvec = readmatrix(strcat(path, filesep, 'tvec.dat')) * 1000; % convert to ms
for compartment = 1:size(compartments, 1)
    mask = swc(:, 2) == compartment;
    voltage_mean = mean(data(mask, :)); 
    save(strcat(workspace, filesep, sim_folder, filesep, 'Results', filesep, strcat('voltage_', compartments{compartment}, '_', model_name, '.mat')), 'voltage_mean');
    clearvars mask voltage_mean
end
voltage_all_mean = mean(data);
save(strcat(workspace, filesep, sim_folder, filesep, 'Results', filesep, strcat('voltage_all_', model_name, '.mat')), 'voltage_all_mean');
clearvars path data tvec compartment

%% Calcium data
path = strcat(workspace, filesep, sim_folder, filesep, 'Models', filesep, model_name, filesep, 'Results', filesep, 'Calcium', filesep);         
data = readmatrix(strcat(path, filesep, 'Calcium_Simulation_Results', filesep, 'fullCalciumData.txt'))' * 1e6; % convert to umol/l
for compartment = 1:size(compartments, 1)
    mask = swc(:, 2) == compartment;
    ca_mean = mean(data(mask, :)); 
    save(strcat(workspace, filesep, sim_folder, filesep, 'Results', filesep, strcat('calcium_', compartments{compartment}, '_', model_name, '.mat')), 'ca_mean');
    clearvars mask ca_mean
end
ca_all_mean = mean(data);
save(strcat(workspace, filesep, sim_folder, filesep, 'Results', filesep, strcat('calcium_all_', model_name, '.mat')), 'ca_all_mean');
end