% hydraulicImportance.m
% 预处理
clear;clc;close all;tic;
net_file = '..\materials\MOD_5_mean.inp';
damage_info_file_name = 'damage_scenario_case_05.txt';
pre_process
global n_ENrun
n_ENrun = 0 ;
n1 = n_ENrun;
% process_7
priority = struct('serviceability',[],'resilience_mean_serviceability',[],'resilience_mean_recovery_rate',[],'ENrun_num',[]);

% 确定次序
[ best_indivi_isolation_1,best_indivi_recovery_1,best_indivi_isolation_1_id,best_indivi_recovery_1_id ] =straightLineImportance_priority( damage_pipe_info,net_data,Dp_Inspect_mat,Dp_Repair_mat );
DamagePipe_order = unique(damage_pipe_info{1});
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
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel);%评价种群个体适应度
% 后处理，出来结果
priority_straightLineImportance = priority;
priority_straightLineImportance.activity = activity_cell;
priority_straightLineImportance.isolation_priority = best_indivi_isolation_1_id;
priority_straightLineImportance.recovery_priority = best_indivi_recovery_1_id;
priority_straightLineImportance.serviceability = cell2mat(system_serviceability_cell);
mid = cal_resilience_index(priority_straightLineImportance.serviceability);
priority_straightLineImportance.resilience_mean_serviceability = mid.resilience_index_mean_serviceability;
mid.index = 0.9;
priority_straightLineImportance.resilience_mean_recovery_rate = mid.resilience_index_mean_recovery_rate;
mid.delete
priority_straightLineImportance.ENrun_num = n_ENrun;
priority_straightLineImportance.crew_active = schedule.schedule_table_crew_pipeID;
priority_straightLineImportance.active_type = schedule.schedule_table_crew_activeType;
priority_straightLineImportance.calculate_code = results.calculate_code;
save(['test_hydraulic_',damage_info_file_name(1:end-4)],'priority_straightLineImportance');
