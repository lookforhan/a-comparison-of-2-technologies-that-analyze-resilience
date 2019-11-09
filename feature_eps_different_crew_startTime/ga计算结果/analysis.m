clear;clc;close all;tic;
lib_name = 'EPANETx64PDD';
h_name = 'toolkit.h';
net_file = '..\materials\MOD\MOD_5_mean.inp';
damage_info_file = '..\materials\MOD\damage_scenario_case_04.txt';
pre_process
global n_ENrun
n_ENrun = 0 ;
n1 = n_ENrun;
priority = struct('serviceability',[],'resilience_mean_serviceability',[],'resilience_mean_recovery_rate',[],'ENrun_num',[]);
% load data
load('damage_scenario_case_01NEW.mat')
isolate_priority = ga_results.best_indivi_isolation;
replace_priority = ga_results.best_indivi_replacement;
DamagePipe_order = unique(damage_pipe_info{1});
