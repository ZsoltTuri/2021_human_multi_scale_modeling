function action_potential = estimate_activation_threshold(var)
arguments
    var.code_path
    var.sim_path
end
cd(var.code_path);
system('nrniv -nogui TMS_script.hoc');
file = [var.sim_path filesep 'fired.txt'];
wait_for_saving_file('file', file)
action_potential = load(file);
delete(file); 
wait_for_deleting_file('file', file);
end