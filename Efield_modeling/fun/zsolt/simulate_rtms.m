function simulate_rtms(var)
arguments
    var.participant
    var.mesh_path
    var.mesh_name
    var.out_path
    var.ccr
    var.mso
    var.coil_file
    var.coil_path
    var.coilparameters
end

% Compute the coil current rate of change in microA/second (see stimulation intensity)
ccr = var.ccr * var.mso; 

% Start session  
S = sim_struct('SESSION');

% Define I/O
S.fnamehead = fullfile(var.mesh_path, var.mesh_name);
S.pathfem = var.out_path;

% Simulation output fields
S.fields = 'eE';        % electric field vector in R3 and its norm (in V/m)
S.map_to_surf = false;  % map the fields to the middle gray matter surface (false due to headreco)
S.map_to_fsavg = false; % map the fields to the FsAverage template (false due to headreco)
S.map_to_mni = true;    % map the fields to the MNI template (using a non-linear transformation)

% Add TMS to the session
S.poslist{1} = sim_struct('TMSLIST');
% TMS coil filename, coil path
S.poslist{1}.fnamecoil = fullfile(var.coil_path, var.coil_file); 
% TMS coil affine transformation matrix
S.poslist{1}.pos(1).matsimnibs = var.coilparameters; 
% Anisotropy type
S.poslist{1}.anisotropy_type = 'scalar'; 
% Stimulation intensity
S.poslist{1}.pos(1).didt = ccr * 1000000;
% Run SimNIBS
run_simnibs(S);
end