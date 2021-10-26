function threshold_tms_1(idx)
% Estimate the action potential threshold for single-pulse TMS. 

%% Set preliminaires
workspace_path = strcat(filesep, 'pfs', filesep, 'work7', filesep, 'workspace', filesep, 'scratch', filesep, 'fr_zt1001-MSM-0');
repository = '2021_human_msm';
sim_folder = 'sim_msm';
workspace = strcat(workspace_path, filesep, repository);
addpath(genpath(strcat(workspace, filesep, 'fun', filesep))); 
run(strcat(workspace, filesep, sim_folder, filesep, 'Model_Generation', filesep, 'lib', filesep, 'init_t2n_trees.m'));

%% Simulation parameters
mso_max = 101; % maximum stimulator output
syn_weight_val = '0.000000'; % define the weigth of an excitatory synapse (zero = no synaptic input)
sim = 'spTMS';
participant = num2str(idx);

%% Get cell locations
radius = 15;
targets = {'dlpfc', 'prg'}';
cell_locations = cell(1, size(targets, 1));
for t = 1:size(targets, 1)
    target = targets{t};
    gray_matter_roi_center = load(strcat(workspace, filesep, 'data', filesep, 'gray_matter_roi_center', filesep, target, filesep, strcat('p', participant, '_gray_matter_roi_center.mat')));
    gray_matter_roi_center = cell2mat(struct2cell(gray_matter_roi_center));
    mesh_path = strcat(workspace, filesep, 'data', filesep, 'efm', filesep, target, filesep, 'p', participant, filesep);
    mesh_file = strcat('p', participant, '_pos_5_angle_45_cropped.msh');
    mesh = mesh_load_gmsh4(fullfile(mesh_path, mesh_file));
    mesh_surf = mesh_extract_regions(mesh, 'elemtype', 'tri', 'region_idx', 1002); 
    surf_centers = mesh_get_triangle_centers(mesh_surf);
    roi = sqrt(sum(bsxfun(@minus, surf_centers, gray_matter_roi_center).^2, 2)) <= radius; 
    cell_locations{:, t} = surf_centers(roi, :);
end

%% Define target
target = 'dlpfc';

%% Couple script
run_coupling('workspace', workspace, 'sim_folder', sim_folder, 'participant_idx', participant, 'targets', targets, 'target', target, 'sim', sim, 'cell_locations', cell_locations)

%% Create parallel pool
pc = parcluster('local');
num_workers = str2num(getenv('SLURM_NPROCS'));
parpool_tmpdir = strcat(getenv('TMP'), filesep, '.matlab', filesep, 'local_cluster_jobs', filesep, 'slurm_jobID_', getenv('SLURM_JOB_ID'));
mkdir(parpool_tmpdir);
pc.JobStorageLocation = parpool_tmpdir;
parpool(pc, num_workers);
poolobj = gcp('nocreate');

%% Prepare folders for parallelized multi-scale modeling
prepare_folders('workspace', workspace, 'sim_folder', sim_folder, 'participant_idx', participant, 'targets', targets, 'target', target, 'sim', sim, 'cell_locations', cell_locations)

%% Estimate activation threshold (parallelized multi-scale modeling)
run_multi_scale_modeling('workspace', workspace, 'sim_folder', sim_folder, 'participant_idx', participant, 'targets', targets, 'target', target, 'sim', sim, ...
                         'cell_locations', cell_locations, 'mso_max', mso_max, 'syn_weight_val', syn_weight_val);
delete(poolobj);

end