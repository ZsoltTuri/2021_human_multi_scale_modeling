function create_parameter_file(var)
% Create parameter file used by the couple_script() function in step 4 SimNIBS NEURON Coupling.
% Author:   Opitz lab, 2020
% Modified: Zsolt Turi, 2021
%--------------------------------------------------------------------------
arguments 
    var.meshfile
    var.meshpath
    var.nrnloc
    var.nrndpth
    var.nrnfile
    var.nrnpath
    var.nrnaxs
    var.nrnori
    var.scale_E
    var.respath
    var.parameters_file
end
%--------------------------------------------------------------------------
% write to parameter file
fid = fopen([var.respath filesep var.parameters_file],'wt');
fprintf(fid, '%% FEM mesh file name\n');
fprintf(fid, ['meshfile = ''' var.meshfile ''';\n']);
fprintf(fid, '%% FEM mesh pathway\n');
fprintf(fid, ['meshpath = ''' var.meshpath ''';\n']);
% fprintf(fid, ['meshpath = ''' strrep(var.meshpath,'\','\\'), '\\', ''';\n']);
fprintf(fid, '%% neuron location\n');
fprintf(fid, ['nrnloc = [' num2str(var.nrnloc) '];\n']);
fprintf(fid, '%% neuron depth\n');
fprintf(fid, ['nrndpth = ' num2str(var.nrndpth) ';\n']);
fprintf(fid, '%% neuron segment coordinates file name\n');
fprintf(fid, ['nrnfile = ''' var.nrnfile ''';\n']);
% fprintf(fid, ['nrnfile = ''' strrep(var.nrnfile,'\','\\') ''';\n']);
fprintf(fid, '%% neuron segment coordinates pathway\n');
fprintf(fid, ['nrnpath = ''' var.nrnpath ''';\n']);
% fprintf(fid, ['nrnpath = ''' strrep(var.nrnpath,'\','\\'), '\\', ''';\n']);
fprintf(fid, '%% neuron axis\n');
fprintf(fid, ['nrnaxs = [' num2str(var.nrnaxs) '];\n']);
fprintf(fid, '%% neuron desired oriention\n');
if isempty(var.nrnori)
    fprintf(fid, 'nrnori = [];\n');
else
    fprintf(fid, ['nrnori = [' num2str(var.nrnori) '];\n']);
end
fprintf(fid, '%% E-field scaling factor\n');
fprintf(fid, ['scale_E = ' num2str(var.scale_E) ';\n']);
fprintf(fid, '%% results directory\n');
fprintf(fid, ['respath = ''' var.respath ''';\n']);
% fprintf(fid, ['respath = ''' strrep(var.respath,'\','\\'), '\\', ''';\n']);
fclose(fid);
%--------------------------------------------------------------------------
end