% straightLineDistance.m
clear;clc;close all;tic;
net_file = '..\materials\MOD_5_mean.inp';
damage_info_file_name = 'damage_scenario_case_03_1.txt';
pre_process
global n_ENrun
n_ENrun = 0 ;
n1 = n_ENrun;
% ������ܵ�ʱ��
disp(damage_info_file_name);
priority = struct('serviceability',[],'resilience_mean_serviceability',[],'resilience_mean_recovery_rate',[]);
% ȷ������
best_indivi_isolation_1_cell =damage_pipe_info{5}(damage_pipe_info{3}==2);
best_indivi_recovery_1_2_cell = damage_pipe_info{5}(damage_pipe_info{3}==1);
mid = PipeSort(net_data,best_indivi_isolation_1_cell);
mid.SortStraightLineDistance2Reservoirs;%���յ�ˮԴ�����С��������
best_indivi_isolation_1_id = mid.sortPipeID;
best_indivi_isolation_1 = cell2mat(mid.sortPipeLocb)';
mid.delete
mid = PipeSort(net_data,best_indivi_recovery_1_2_cell);
mid.SortStraightLineDistance2Reservoirs;%���յ�ˮԴ�����С��������
best_indivi_recovery_1_id = [best_indivi_isolation_1_id;mid.sortPipeID];
best_indivi_recovery_1_2 = cell2mat(mid.sortPipeLocb)';
best_indivi_recovery_1 = [best_indivi_isolation_1,best_indivi_recovery_1_2];
mid.delete
DamagePipe_order = unique(damage_pipe_info{1});
% ��ʼ����
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
% �����������
priority_straighLineDistance = priority;
priority_straighLineDistance.activity = activity_cell;
priority_straighLineDistance.isolation_priority = best_indivi_isolation_1_id;
priority_straighLineDistance.recovery_priority = best_indivi_recovery_1_id;
priority_straighLineDistance.serviceability = cell2mat(system_serviceability_cell);
mid = cal_resilience_index(priority_straighLineDistance.serviceability);
priority_straighLineDistance.resilience_mean_serviceability = mid.resilience_index_mean_serviceability;
mid.index = 0.9;
priority_straighLineDistance.resilience_mean_recovery_rate = mid.resilience_index_mean_recovery_rate;
mid.delete
priority_straighLineDistance.ENrun_num = n_ENrun;
priority_straighLineDistance.crew_active = schedule.schedule_table_crew_pipeID;
priority_straighLineDistance.active_type = schedule.schedule_table_crew_activeType;
priority_straighLineDistance.calculate_code = results.calculate_code;
save(['test_LosAngeles_',damage_info_file_name(1:end-4)],'priority_straighLineDistance');
delete .\results\_*
toc
clearvars -EXCEPT priority_straighLineDistance schedule results net_data
