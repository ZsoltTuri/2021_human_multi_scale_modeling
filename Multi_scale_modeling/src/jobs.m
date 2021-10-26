%% Info
% Create shell scripts for E-field and multi-scale modeling on HPC.
% I run this script on my local PC and upload its output (shell files) to HPC via git.

%% Set preliminaries
clear; close all; clc;
repository = '2021_human_msm';
sim_folder = 'sim_efm';
path = ['C:' filesep 'Prg-Win' filesep 'simulations' filesep repository];
addpath([path filesep 'fun'])
addpath(['C:' filesep 'Prg-Win' filesep 'SIMNIBS_323' filesep 'matlab']);
cd(path)
% HPC workspace 
workspace_path = [filesep 'pfs' filesep 'work7' filesep 'workspace' filesep 'scratch' filesep 'fr_zt1001-MSM-0'];
workspace = [workspace_path filesep repository];

%% Prepare shell scripts for multi-scale modeling: initialize
out_name = '2021_human_msm_init.sh';
create_shell_script_MSM_init('out_path', path, 'out_name', out_name, 'workspace', workspace);

%% Prepare shell scripts for multi-scale modeling: model generation
bat_name = 'model_generation.sh';
jobname = 'model_generation';
nodes = '1';
tasks = '1';
tasks_nodes = '1';
memory = '6';
wallclock = '00:15:00';
create_shell_script_MSM_mod_gen('out_path', path, 'out_name', bat_name, 'jobname', jobname, 'nodes', nodes, 'tasks', tasks, 'tasks_nodes', tasks_nodes, 'memory', memory, 'wallclock', wallclock, 'workspace', workspace);

%% Prepare shell scripts for multi-scale modeling: threshold estimation
% single synaptic input
out_name = 'threshold_syn_1.sh';
jobname = 'threshold_estimation_syn_1';
nodes = '1';
tasks = '1';
tasks_nodes = '1';
memory = '5';
array = '1';
wallclock = '00:30:00';
create_shell_script_MSM_threshold_syn('out_path', path, 'out_name', out_name, 'jobname', jobname, 'nodes', nodes, 'tasks', tasks, 'tasks_nodes', tasks_nodes, 'memory', memory, 'wallclock', wallclock, 'array', array, 'workspace', workspace);

% single-pulse TMS
out_name = 'threshold_tms_1.sh';
jobname = 'threshold_estimation_tms_1';
nodes = '1';
tasks = '2';
tasks_nodes = '4';
memory = '16';
array = '10';
wallclock = '72:00:00';
create_shell_script_MSM_threshold_spTMS('out_path', path, 'out_name', out_name, 'jobname', jobname, 'nodes', nodes, 'tasks', tasks, 'tasks_nodes', tasks_nodes, 'memory', memory, 'wallclock', wallclock, 'array', array, 'workspace', workspace);

% single-pulse TMS with synaptic input
out_name = 'threshold_tms_syn_1.sh';
jobname = 'threshold_estimation_tms_syn_1';
nodes = '1';
tasks = '2';
tasks_nodes = '4';
memory = '16';
array = '3-4';
wallclock = '70:00:00';
create_shell_script_MSM_threshold_spTMS_syn('out_path', path, 'out_name', out_name, 'jobname', jobname, 'nodes', nodes, 'tasks', tasks, 'tasks_nodes', tasks_nodes, 'memory', memory, 'wallclock', wallclock, 'array', array, 'workspace', workspace);

%% Prepare shell scripts for multi-scale modeling
out_name = 'simulate_rTMS.sh';
jobname = 'simulate_rTMS';
nodes = '1';
tasks = '1';
tasks_nodes = '1';
memory = '32';
array = '2';
wallclock = '20:00:00';
create_shell_script_MSM_simulate_rTMS('out_path', path, 'out_name', out_name, 'jobname', jobname, 'nodes', nodes, 'tasks', tasks, 'tasks_nodes', tasks_nodes, 'memory', memory, 'wallclock', wallclock, 'array', array, 'workspace', workspace);

%% Prepare shell script for analyzing multi-scale modeling
out_name = 'analyze_rTMS.sh';
jobname = 'analyze_rTMS';
nodes = '1';
tasks = '1';
tasks_nodes = '1';
memory = '45';
array = '2';
wallclock = '00:45:00';
create_shell_script_MSM_analyze_rTMS('out_path', path, 'out_name', out_name, 'jobname', jobname, 'nodes', nodes, 'tasks', tasks, 'tasks_nodes', tasks_nodes, 'memory', memory, 'wallclock', wallclock, 'array', array, 'workspace', workspace);
