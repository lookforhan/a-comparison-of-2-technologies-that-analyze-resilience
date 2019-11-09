% greedyImportance.m
% 预处理
clear;clc;close all;tic;
net_file = '..\materials\MOD\MOD_5_mean.inp';
damage_info_file_name = 'damage_scenario_case_03.txt';
pre_process
global n_ENrun
n_ENrun = 0 ;
n1 = n_ENrun;
pre_time_calculate = (numel(damage_pipe_info{5}(damage_pipe_info{3}==2))*(numel(damage_pipe_info{5}(damage_pipe_info{3}==2))+1)/2 ...
+numel(damage_pipe_info{5}(damage_pipe_info{3}))*(numel(damage_pipe_info{5}(damage_pipe_info{3}))+1)/2)*0.4;
disp(['预计需要时间：',num2str(pre_time_calculate)])
% process_7
priority = struct('serviceability',[],'resilience_mean_serviceability',[],'resilience_mean_recovery_rate',[],'ENrun_num',[]);

% 确定次序
[ best_indivi_isolation_1,best_indivi_recovery_1,best_indivi_isolation_1_id,best_indivi_recovery_1_id ] =greedyImportance_notime_priority( damage_pipe_info,net_data,Dp_Inspect_mat,Dp_Repair_mat,temp_inp_file,pipe_relative );
DamagePipe_order = unique(damage_pipe_info{1});
delete .\results\_*
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
priority_greedyImportance = priority;
priority_greedyImportance.activity = activity_cell;
priority_greedyImportance.isolation_priority = best_indivi_isolation_1_id;
priority_greedyImportance.recovery_priority = best_indivi_recovery_1_id;
priority_greedyImportance.serviceability = cell2mat(system_serviceability_cell);
mid = cal_resilience_index(priority_greedyImportance.serviceability);
priority_greedyImportance.resilience_mean_serviceability = mid.resilience_index_mean_serviceability;
mid.index = 0.9;
priority_greedyImportance.resilience_mean_recovery_rate = mid.resilience_index_mean_recovery_rate;
mid.delete
priority_greedyImportance.ENrun_num = n_ENrun;
priority_greedyImportance.crew_active = schedule.schedule_table_crew_pipeID;
priority_greedyImportance.active_type = schedule.schedule_table_crew_activeType;
priority_greedyImportance.calculate_code = results.calculate_code;
save(['test_greedy_',damage_info_file_name(1:end-4),'_5000'],'priority_greedyImportance');
delete .\results\_*
toc
numel(priority_greedyImportance.calculate_code)
sum(priority_greedyImportance.calculate_code~=0)
anss = priority_greedyImportance.serviceability;
% plot_now(priority_greedyImportance,damage_info_file_name)
function plot_now(priority_straighLineDistance,damage_info_file_name)
errcode = priority_straighLineDistance.calculate_code;
Time = 1:numel(errcode);
fig = Plot(Time,errcode);
fig.XLabel = 'Time (h)';
fig.YLabel = 'error code';
fig.Title = [damage_info_file_name(1:end-4),' errcode in process'];
fig.export(['test_straightLineDistance_',damage_info_file_name(1:end-4),'errcode','.png']);
fig.delete

% 供水满意率曲线
serviceability = priority_straighLineDistance.serviceability;
fig = Plot(Time,serviceability);
fig.XLabel = 'Time (h)';
fig.YLabel = 'Serviceability';
fig.Title = [damage_info_file_name(1:end-4),' serviceability v.s. Time'];
fig.export(['test_straightLineDistance_',damage_info_file_name(1:end-4),'serviceability','.png']);
fig.delete

% 修正作图
errcode_loc = find(errcode~=0);
reliable_code_loc  = find(errcode ==0); 
err_serviceability = priority_straighLineDistance.serviceability(errcode_loc);
reliable_time = Time(reliable_code_loc);
reliable_serviceability = priority_straighLineDistance.serviceability(reliable_code_loc);
fig = Plot(reliable_time,reliable_serviceability);
fig.XLabel = 'Time (h)';
fig.YLabel = 'Serviceability';
fig.Title = [damage_info_file_name(1:end-4),' reliable serviceability v.s. Time'];
fig.export(['test_straightLineDistance_',damage_info_file_name(1:end-4),'reliable_serviceability','.png']);
fig.delete;

end