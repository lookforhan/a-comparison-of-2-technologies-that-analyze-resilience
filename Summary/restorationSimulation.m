clear;clc;close all;tic;
net_file = '..\materials\MOD\MOD_5_mean.inp';
damage_scenario = 3;
strategy = 'GAOM';%'GAOM';%'DCBM';%'MCM';%'SCM'
damage_info_file_name = ['damage_scenario_case_0',num2str(damage_scenario),'.txt'];
pre_process
global n_ENrun
n_ENrun = 0 ;
n1 = n_ENrun;
priority = struct('serviceability',[],'resilience_mean_serviceability',[],'resilience_mean_recovery_rate',[]);
% 确定次序
filename = [strategy,'case',num2str(damage_scenario),'.mat'];
load(filename);
best_indivi_isolation_1 = cell2mat(priority_pipe.isolate_loc)';
best_indivi_recovery_1 = cell2mat(priority_pipe.recovery_loc)';
best_indivi_isolation_1_id = priority_pipe.isolate_id;
best_indivi_recovery_1_id = priority_pipe.recovery_id;
DamagePipe_order = unique(damage_pipe_info{1});

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
priority_results = priority;
priority_results.activity = activity_cell;
priority_results.isolation_priority = best_indivi_isolation_1_id;
priority_results.recovery_priority = best_indivi_recovery_1_id;
priority_results.serviceability = cell2mat(system_serviceability_cell);
mid = cal_resilience_index(priority_results.serviceability);
priority_results.resilience_mean_serviceability = mid.resilience_index_mean_serviceability;
mid.index = 0.9;
priority_results.resilience_mean_recovery_rate = mid.resilience_index_mean_recovery_rate;
mid.delete
priority_results.ENrun_num = n_ENrun;
priority_results.crew_active = schedule.schedule_table_crew_pipeID;
priority_results.active_type = schedule.schedule_table_crew_activeType;
priority_results.calculate_code = results.calculate_code;
priority_results.result = results;
output = [activity_cell,system_serviceability_cell,num2cell(results.calculate_code)];
writematrix(priority_results.resilience_mean_serviceability,[strategy,'4','.xlsx'],'sheet',['Scenario',num2str(damage_scenario)])
writecell(output,[strategy,'3','.xlsx'],'sheet',['Scenario',num2str(damage_scenario)]);
if libisloaded(lib_name)
    unloadlibrary(lib_name);
end