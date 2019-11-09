% hydraulicImportance.m
% 预处理
clear;clc;close all;tic;
net_file = '..\materials\MOD\MOD_5_mean.inp';
damage_info_file_name = 'damage_scenario_case_09.txt';
pre_process
hydraulic_importance = pipeHydraulicImportant(net_file);
global n_ENrun
n_ENrun = 0 ;
n1 = n_ENrun;
% process_7
priority = struct('serviceability',[],'resilience_mean_serviceability',[],'resilience_mean_recovery_rate',[],'ENrun_num',[]);

% 确定次序
% [ best_indivi_isolation_1,best_indivi_recovery_1,best_indivi_isolation_1_id,best_indivi_recovery_1_id ] = hydralicImpotance_priority( damage_pipe_info,net_data );
best_indivi_isolation_1_cell =damage_pipe_info{5}(damage_pipe_info{3}==2);
best_indivi_recovery_1_2_cell = damage_pipe_info{5}(damage_pipe_info{3}==1);
mid = PipeSort(net_data,best_indivi_isolation_1_cell);
mid.Parameters = hydraulic_importance;
mid.SortByParameters;%按照Parameter从大到小排序
best_indivi_isolation_1_id = mid.sortPipeID;
best_indivi_isolation_1 = cell2mat(mid.sortPipeLocb)';
mid.delete
mid = PipeSort(net_data,best_indivi_recovery_1_2_cell);
mid.Parameters = hydraulic_importance;
mid.SortByParameters;%按照Parameter从大到小排序
best_indivi_recovery_1_id = [mid.sortPipeID;best_indivi_isolation_1_id];
best_indivi_recovery_1_2 = cell2mat(mid.sortPipeLocb)';
best_indivi_recovery_1 = [best_indivi_recovery_1_2,best_indivi_isolation_1];
mid.delete

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
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel,0);%评价种群个体适应度
% 后处理，出来结果
priority_hydraulicImportance = priority;
priority_hydraulicImportance.activity = activity_cell;
priority_hydraulicImportance.isolation_priority = best_indivi_isolation_1_id;
priority_hydraulicImportance.recovery_priority = best_indivi_recovery_1_id;
priority_hydraulicImportance.serviceability = cell2mat(system_serviceability_cell);
mid = cal_resilience_index(priority_hydraulicImportance.serviceability);
priority_hydraulicImportance.resilience_mean_serviceability = mid.resilience_index_mean_serviceability;
mid.index = 0.9;
priority_hydraulicImportance.resilience_mean_recovery_rate = mid.resilience_index_mean_recovery_rate;
mid.delete
priority_hydraulicImportance.ENrun_num = n_ENrun;
priority_hydraulicImportance.crew_active = schedule.schedule_table_crew_pipeID;
priority_hydraulicImportance.active_type = schedule.schedule_table_crew_activeType;
priority_hydraulicImportance.calculate_code = results.calculate_code;
save(['test_hydraulic_pdd',damage_info_file_name(1:end-4)],'priority_hydraulicImportance');
sum(priority_hydraulicImportance.calculate_code~=0)
numel(priority_hydraulicImportance.calculate_code)
