function run_coupling(var)
arguments
    var.workspace
    var.sim_folder
    var.participant_idx
    var.target
    var.sim
    var.cell_locations
    var.cell_idx
end

workspace = var.workspace;
sim_folder = var.sim_folder;
participant = var.participant_idx;
target = var.target;
sim = var.sim;
cell_locations = var.cell_locations;
model_name = strcat('Aberra_human_L5_p', participant, '_', target, '_', sim);
mesh_path = strcat(workspace, filesep, 'data', filesep, 'efm', filesep, target, filesep, 'p', participant, filesep);
mesh_file = strcat('p', participant, '_pos_5_angle_45_cropped.msh');
nloc = size(cell_locations, 1);
counter = zeros(size(cell_locations, 2), 1);
for L = 1:nloc
    cd(strcat(workspace, filesep, sim_folder, filesep, 'Models', filesep, model_name, filesep, 'Code', filesep, 'E-Field_Coupling'))
    folder_name = strcat(workspace, filesep, sim_folder, filesep, 'Models', filesep, model_name, filesep, 'Results', filesep, 'E-field_Coupling');
    create_folder('folder_name', folder_name)
    cell_location = cell_locations(L, :);
    meshfile = mesh_file;
    meshpath = mesh_path;
    nrnloc = cell_location;
    nrndpth = 1.25;
    nrnfile = 'locs_all_seg.txt';
    nrnpath = strcat('..', filesep, '..', filesep, 'Results', filesep, 'NEURON', filesep, 'locs', filesep); 
    nrnaxs = [0  1  0];
    nrnori = []; 
    scale_E = 1;
    respath = strcat('..', filesep, '..', filesep, 'Results', filesep, 'E-field_Coupling');
    % parameters_file = strcat('parameters_', target, '_loc_', num2str(L), '.txt');
    parameters_file = strcat('parameters_', target, '_loc_', var.cell_idx, '.txt');
    create_parameter_file('meshfile', meshfile, 'meshpath', meshpath, 'nrnloc', nrnloc, 'nrndpth', nrndpth, 'nrnfile', nrnfile, 'nrnpath', nrnpath, 'nrnaxs', nrnaxs, ...
                          'nrnori', nrnori, 'scale_E', scale_E, 'respath', respath, 'parameters_file', parameters_file);
    param_file = strcat(workspace, filesep, sim_folder, filesep, 'Models', filesep, model_name, filesep, 'Results', filesep, 'E-field_Coupling', filesep, parameters_file);
    % quasipotentials_file = strcat('quasipotentials_', target, '_loc_', num2str(L), '.txt');
    quasipotentials_file = strcat('quasipotentials_', target, '_loc_', var.cell_idx, '.txt');
    counter(L, 1) = couple_script('param_file', param_file, 'quasipotentials_file', quasipotentials_file);
end
save(strcat(workspace, filesep, sim_folder, filesep, 'Results', filesep, strcat('p', participant,  '_', target, '_counter.mat')), 'counter')
end
