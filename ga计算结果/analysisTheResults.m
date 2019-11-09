clear;clc;close all;tic;
net_file = '..\materials\MOD\MOD_5_mean.inp';
damage_info_file_name = 'damage_scenario_case_05.txt';
pre_process
global n_ENrun
n_ENrun = 0 ;
n1 = n_ENrun;
priority = struct('serviceability',[],'resilience_mean_serviceability',[],'resilience_mean_recovery_rate',[],'ENrun_num',[]);

% load data

% load('damage_scenario_case_01.mat')
% load('damage_scenario_case_02.mat')
% load('damage_scenario_case_03.mat')
% load('damage_scenario_case_04relay50_50.mat')
load('damage_scenario_case_05relay50_50_50.mat')
% load('damage_scenario_case_06_new_100.mat')
% load('damage_scenario_case_07.mat');
% load('damage_scenario_case_08.mat');
% load('damage_scenario_case_09_new_100.mat')
best_indivi_isolation_1 = ga_results.best_indivi_isolation;
best_indivi_recovery_1 = ga_results.best_indivi_replacement;
% best_indivi_recovery_1 = ga_results.best_indivi_recovery;
% best_indivi_isolation_1 = [165,287,123,317];
% best_indivi_recovery_1 = [317,165,44,154,149,48,60,207,...
%     240,164,126,109,203,147,152,83,...
%     228,221,223,71,188,99,5,123,...
%     32,278,238,132,227,307,287,316];
DamagePipe_order = unique(damage_pipe_info{1});
best_indivi_isolation_1_id = net_data{5,2}(best_indivi_isolation_1);
best_indivi_recovery_1_id = net_data{5,2}(best_indivi_recovery_1);
% 水力模拟
[Fitness,...
    BreakPipe_result,...
    RepairCrew_result,...
    system_serviceability_cell,...
    activity_cell,results,schedule]...
    =fit8_recovery...
    (best_indivi_isolation_1,best_indivi_recovery_1,...
    DamagePipe_order,RepairCrew,...
    Dp_Inspect_mat,...
    Dp_Repair_mat,Dp_Travel_mat,...
    net_data,...
    out_dir,...
    temp_inp_file,...
    pipe_relative,...
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel,0);%评价种群个体适应度

% 后处理，出来结果
priority_ga_best = priority;
priority_ga_best.activity = activity_cell;
priority_ga_best.isolation_priority = best_indivi_isolation_1_id;
priority_ga_best.recovery_priority = best_indivi_recovery_1_id;
priority_ga_best.serviceability = cell2mat(system_serviceability_cell);
mid = cal_resilience_index(priority_ga_best.serviceability);
priority_ga_best.resilience_mean_serviceability = mid.resilience_index_mean_serviceability;
mid.index = 0.9;
priority_ga_best.resilience_mean_recovery_rate = mid.resilience_index_mean_recovery_rate;
mid.delete
priority_ga_best.ENrun_num = n_ENrun;
priority_ga_best.crew_active = schedule.schedule_table_crew_pipeID;
priority_ga_best.active_type = schedule.schedule_table_crew_activeType;
priority_ga_best.calculate_code = results.calculate_code;
save(['test_ga_best_pdd',damage_info_file_name(1:end-4)],'priority_ga_best');
sum(priority_ga_best.calculate_code~=0)
numel(priority_ga_best.calculate_code)