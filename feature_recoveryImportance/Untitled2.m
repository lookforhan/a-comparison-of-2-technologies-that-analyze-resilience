clear;clc;close all;tic;
net_file = '..\materials\MOD\MOD_5_mean.inp';
damage_info_file_name = 'damage_scenario_case_09.txt';
pre_process
global n_ENrun
n_ENrun = 0 ;
n1 = n_ENrun;
priority = struct('serviceability',[],'resilience_mean_serviceability',[],'resilience_mean_recovery_rate',[],'ENrun_num',[]);

% load data

% load('test_greedy_adjustdamage_scenario_case_01_5000_new_new.mat')
% load('test_greedy_adjustdamage_scenario_case_02_5000_new_new.mat')
% load('test_greedy_adjustdamage_scenario_case_03_5000_new_new.mat')
% load('test_greedy_adjustdamage_scenario_case_04_5000_new_new.mat')
% load('test_greedy_adjustdamage_scenario_case_05_5000_new_new.mat')
% load('test_greedy_adjustdamage_scenario_case_06_5000_new_new.mat')
% load('test_greedy_adjustdamage_scenario_case_07_5000_new_new.mat')
% load('test_greedy_adjustdamage_scenario_case_08_5000_new_new.mat')
load('test_greedy_adjustdamage_scenario_case_09_5000_new_new.mat')
best_indivi_isolation_1 = priority_greedyImportance.isolation_priority_loc;
best_indivi_recovery_1 = priority_greedyImportance.recovery_priority_loc;

% best_indivi_isolation_1 = [165,287,317,123];
% best_indivi_recovery_1 = ...
% [165,317,44,154,207,60,149,48,...
%     240,109,203,164,126,147,83,152,...
%     228,223,71,278,188,227,99,5,...
%     123,32,238,221,132,307,287,316];
DamagePipe_order = unique(damage_pipe_info{1});
% best_indivi_isolation_1_id = priority_greedyImportance.isolation_priority;
% best_indivi_recovery_1_id = priority_greedyImportance.recovery_priority;
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
priority_greedy_best = priority;
priority_greedy_best.activity = activity_cell;
priority_greedy_best.isolation_priority = best_indivi_isolation_1_id;
priority_greedy_best.recovery_priority = best_indivi_recovery_1_id;
priority_greedy_best.serviceability = cell2mat(system_serviceability_cell);
mid = cal_resilience_index(priority_greedy_best.serviceability);
priority_greedy_best.resilience_mean_serviceability = mid.resilience_index_mean_serviceability;
mid.index = 0.9;
priority_greedy_best.resilience_mean_recovery_rate = mid.resilience_index_mean_recovery_rate;
mid.delete
priority_greedy_best.ENrun_num = n_ENrun;
priority_greedy_best.crew_active = schedule.schedule_table_crew_pipeID;
priority_greedy_best.active_type = schedule.schedule_table_crew_activeType;
priority_greedy_best.calculate_code = results.calculate_code;
save(['test_greedy1104_best_pdd',damage_info_file_name(1:end-4)],'priority_greedy_best');
sum(priority_greedy_best.calculate_code~=0)
numel(priority_greedy_best.calculate_code)