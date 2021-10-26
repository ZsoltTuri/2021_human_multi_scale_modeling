function calcium_modeling(var)
arguments
    var.workspace
    var.participant
    var.target
    var.sim_folder
    var.sim
    var.cell_idx
end

model_name = strcat('Aberra_human_L5_p', var.participant, '_', var.target, '_', var.sim, '_loc_', var.cell_idx);
cd(strcat(var.workspace, filesep, var.sim_folder, filesep, 'Models', filesep, model_name, filesep, 'Code', filesep, 'Calcium', filesep))
% prepare folders
cpath = strcat(var.workspace, filesep, var.sim_folder, filesep, 'Models', filesep, model_name, filesep, 'Results', filesep, 'Calcium', filesep);
vpath = strcat(var.workspace, filesep, var.sim_folder, filesep, 'Models', filesep, model_name, filesep, 'Results', filesep, 'Calcium', filesep, 'Converted_Voltage_Traces', filesep);
opath = strcat(var.workspace, filesep, var.sim_folder, filesep, 'Models', filesep, model_name, filesep, 'Results', filesep, 'Calcium', filesep, 'Calcium_Simulation_Results', filesep);
if (not(isfolder(cpath)))
    mkdir(cpath);
    mkdir(vpath);
    mkdir(opath);
end  
disp('Folders successfully created.')
run('export_data.m')
wait_for_converting_voltage_data('folder', vpath);
% create calcium shell script
tvec = readmatrix(strcat(var.workspace, filesep, var.sim_folder, filesep, 'Models', filesep, model_name, filesep, 'Results', filesep, 'NEURON', filesep, 'tvec.dat')); 
ug4_path = ['$HOME' filesep 'ug4' filesep 'bin' filesep 'ugshell'];
ex = strcat(var.workspace, filesep, var.sim_folder, filesep, 'Models', filesep, model_name, filesep, 'Code', filesep, 'Calcium', filesep, 'vdccFullCellCalcium.lua');
grid = strcat(var.workspace, filesep, var.sim_folder, filesep, 'Models', filesep, model_name, filesep, 'Results', filesep, 'Calcium', filesep, 'neuron_out.swc');
numRefs = num2str(0);
setting = 'none';
dt = sprintf('%.7f', 0.05 * 1e-3); 
endTime = num2str(tvec(end));
pstep = sprintf('%.7f', 1e-3); % num2str(1.0e-5);
vmData = vpath;
outName = opath;
solver = 'GS';
minDef = num2str(1e-11);
numNewton = num2str(5); 
vSampleRate = sprintf('%.7f', abs(tvec(2) - tvec(1)) * 1e-3); 
filename = strcat(var.workspace, filesep, var.sim_folder, filesep, 'Models', filesep, model_name, filesep, 'Results', filesep, 'Calcium', filesep, 'calciumshellscript.sh');
create_calciumshellscript('ug4_path', ug4_path, 'ex', ex, 'grid', grid, 'numRefs', numRefs, 'setting', setting, 'dt', dt, 'endTime', endTime, 'pstep', pstep, 'vmData', vmData, ...
                          'outName', outName, 'solver', solver, 'minDef', minDef, 'numNewton', numNewton, 'vSampleRate', vSampleRate, 'filename', filename);
% file permission(s)
fileattrib(filename, '+x', 'a') 
% run calcium modeling
system(sprintf('sh %s', filename), '-echo');