% hydraulicImportance.m
% Ԥ����
clear;clc;close all;tic;
net_file = '..\materials\MOD_5_mean.inp';
damage_info_file_name = 'damage_scenario_case_05.txt';
pre_process
global n_ENrun
n_ENrun = 0 ;
n1 = n_ENrun;
% process_7
priority = struct('serviceability',[],'resilience_mean_serviceability',[],'resilience_mean_recovery_rate',[],'ENrun_num',[]);

% ȷ������
[ best_indivi_isolation_1,best_indivi_recovery_1,best_indivi_isolation_1_id,best_indivi_recovery_1_id ] =recoveryImportance_priority( damage_pipe_info,net_data,Dp_Inspect_mat,Dp_Repair_mat );
DamagePipe_order = unique(damage_pipe_info{1});
% ˮ��ģ��
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
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel);%������Ⱥ������Ӧ��
% �������������
priority_recoveryImportance = priority;
priority_recoveryImportance.activity = activity_cell;
priority_recoveryImportance.isolation_priority = best_indivi_isolation_1_id;
priority_recoveryImportance.recovery_priority = best_indivi_recovery_1_id;
priority_recoveryImportance.serviceability = cell2mat(system_serviceability_cell);
mid = cal_resilience_index(priority_recoveryImportance.serviceability);
priority_recoveryImportance.resilience_mean_serviceability = mid.resilience_index_mean_serviceability;
mid.index = 0.9;
priority_recoveryImportance.resilience_mean_recovery_rate = mid.resilience_index_mean_recovery_rate;
mid.delete
priority_recoveryImportance.ENrun_num = n_ENrun;
priority_recoveryImportance.crew_active = schedule.schedule_table_crew_pipeID;
priority_recoveryImportance.active_type = schedule.schedule_table_crew_activeType;
priority_recoveryImportance.calculate_code = results.calculate_code;
save(['test_hydraulic_',damage_info_file_name(1:end-4)],'priority_recoveryImportance');