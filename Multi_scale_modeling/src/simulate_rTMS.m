function simulate_rTMS(idx)
% 1. Perform voltage modeling for a given rTMS protocol.
% 2. Perform calcium modeling for a given rTMS protocol.

%% Set preliminaires
workspace_path = strcat(filesep, 'pfs', filesep, 'work7', filesep, 'workspace', filesep, 'scratch', filesep, 'fr_zt1001-MSM-0');
repository = '2021_human_msm';
sim_folder = 'sim_msm';
workspace = strcat(workspace_path, filesep, repository);
addpath(genpath(strcat(workspace, filesep, 'fun', filesep))); 
run(strcat(workspace, filesep, sim_folder, filesep, 'Model_Generation', filesep, 'lib', filesep, 'init_t2n_trees.m'));

%% Load parameters
participant = num2str(idx);
sim = 'rTMS';
mso = num2str(82); % = 120% RMT for participant ID 2
synaptic_weight = '0.000000';

%% Set cell idx manually!
cell_idx = 2868; %10944 2868 2291;

%% Get cell location
radius = 15;
target = 'dlpfc';
cell_locations = [];
gray_matter_roi_center = load(strcat(workspace, filesep, 'data', filesep, 'gray_matter_roi_center', filesep, target, filesep, strcat('p', participant, '_gray_matter_roi_center.mat')));
gray_matter_roi_center = cell2mat(struct2cell(gray_matter_roi_center));
mesh_path = strcat(workspace, filesep, 'data', filesep, 'efm', filesep, target, filesep, 'p', participant, filesep);
mesh_file = strcat('p', participant, '_pos_5_angle_45_cropped.msh');
mesh = mesh_load_gmsh4(fullfile(mesh_path, mesh_file));
mesh_surf = mesh_extract_regions(mesh, 'elemtype', 'tri', 'region_idx', 1002); 
surf_centers = mesh_get_triangle_centers(mesh_surf);
cell_locations = surf_centers(cell_idx, :);

%% 1. Voltage modeling
run_coupling('workspace', workspace, 'sim_folder', sim_folder, 'participant_idx', participant, 'target', target, 'sim', sim, 'cell_locations', cell_locations, 'cell_idx', num2str(cell_idx))
prepare_folders_forloop('workspace', workspace, 'sim_folder', sim_folder, 'participant_idx', participant, 'target', target, 'sim', sim, 'cell_idx', num2str(cell_idx))
voltage_modeling('workspace', workspace, 'sim_folder', sim_folder, 'sim', sim, 'participant', participant, 'target', target, 'mso', mso, 'cell_idx', num2str(cell_idx))

%% 2. Calcium modeling
calcium_modeling('workspace', workspace, 'sim_folder', sim_folder, 'sim', sim, 'participant', participant, 'target', target, 'cell_idx', num2str(cell_idx))

end