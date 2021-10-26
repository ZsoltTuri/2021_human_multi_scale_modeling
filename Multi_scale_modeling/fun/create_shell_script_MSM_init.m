function create_shell_script_MSM_init(var)
arguments
    var.out_path
    var.out_name
    var.workspace
end
sep = '\\';
linux_sep = '/';
var.out_path = strrep(var.out_path, '\', sep);
var.workspace =  strrep(var.workspace, '\', linux_sep);
space = 32;
fname = [var.out_path linux_sep var.out_name];
fid = fopen(fname, 'wt');
fprintf(fid, '#!/bin/bash \n');
fprintf(fid, strcat('cd', space, var.workspace, linux_sep, ' \n')); 
fprintf(fid, 'rm *.out \n');
fprintf(fid, 'git stash \n');
fprintf(fid, 'git pull origin main \n');
fprintf(fid, 'dos2unix model_generation.sh \n');
fprintf(fid, 'chmod +x model_generation.sh \n');
fprintf(fid, 'dos2unix threshold_syn_1.sh \n');
fprintf(fid, 'chmod +x threshold_syn_1.sh \n');
fprintf(fid, 'dos2unix threshold_tms_1.sh \n');
fprintf(fid, 'chmod +x threshold_tms_1.sh \n');
fprintf(fid, 'dos2unix threshold_tms_syn_1.sh \n');
fprintf(fid, 'chmod +x threshold_tms_syn_1.sh \n');
fprintf(fid, 'dos2unix simulate_rTMS.sh \n');
fprintf(fid, 'chmod +x simulate_rTMS.sh \n');
fprintf(fid, 'dos2unix analyze_rTMS.sh \n');
fprintf(fid, 'chmod +x analyze_rTMS.sh \n');
fprintf(fid, strcat('cd', space, var.workspace, linux_sep, 'sim_msm', linux_sep, 'Model_Generation', linux_sep, 'Aberra_files', linux_sep, 'lib_mech', linux_sep, space, '\n')); 
fprintf(fid, 'nrnivmodl \n');  
fclose(fid);