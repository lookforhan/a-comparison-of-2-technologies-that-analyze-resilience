% adjutstHydraulicImportance.m
% 预处理
clear;clc;close all;tic;
net_file = '..\materials\MOD\MOD_5_mean.inp';
damage_info_file_name = 'damage_scenario_case_05.txt';
pre_process
hydraulic_importance = pipeHydraulicImportant(net_file);
% 水力重要度相对值
hydraulic_importance_max = max(hydraulic_importance);
hydraulic_importance_relative = hydraulic_importance/hydraulic_importance_max;
% 时间相对值
isolation_time_mat = Dp_Inspect_mat(damage_pipe_info{3}==2);
isolation_time_relative_mat = isolation_time_mat/max(isolation_time_mat);
recovery_time_mat = Dp_Repair_mat;
recovery_time_relative_mat = recovery_time_mat/max(recovery_time_mat);
% 管道相对流量
node_relative_NewNode_table = struct2table(node_relative_NewNode);
flow_reservoir_1 = zeros(numel(pipe_relative(:,1)),1);
flow_reservoir_2 = zeros(numel(pipe_relative(:,1)),1);
node_index = libpointer('int32Ptr',0);
node_actual_demand = libpointer('doublePtr',0);
errcode7_1 = calllib(lib_name,'ENopen',temp_inp_file,[out_dir,'damage.rpt'],'');% from 'EPANETx64PDD.dll'
errcode7_2 = calllib(lib_name,'ENsettimeparam',0,0);% 设置模拟历时
errcode7_2_2 = calllib(lib_name,'ENsetoption',0,5000);% 动态链接库中迭代次数
errcode7_3 = calllib(lib_name,'ENsolveH');

for new_reservoirs_num = 1:numel(pipe_relative(:,1))%管道对应的第一个破坏点的泄漏量
    damage_pipe_id = pipe_relative{new_reservoirs_num,1};
    damage_pipe_struct = pipe_relative{new_reservoirs_num,3};
    damage_node1_num = numel(pipe_relative{new_reservoirs_num,3}.damage_node);
    damage_node = pipe_relative{new_reservoirs_num,3}.damage_node;
    [~,loc] = ismember(damage_node,node_relative_NewNode_table.node_id_1);
    reservoir_id_1 = node_relative_NewNode_table.new_reservoir_1{loc};
    [~,~,node_index] = calllib(lib_name,'ENgetnodeindex',reservoir_id_1,node_index);
    [~,node_actual_demand] = calllib(lib_name,'ENgetnodevalue',node_index,9,node_actual_demand);
    flow_reservoir_1(new_reservoirs_num) = node_actual_demand;
    reservoir_id_2 = node_relative_NewNode_table.new_reservoir_2{loc};
    if ~isempty(reservoir_id_2)
        [~,~,node_index] = calllib(lib_name,'ENgetnodeindex',reservoir_id_2,node_index);
        [~,node_actual_demand] = calllib(lib_name,'ENgetnodevalue',node_index,9,node_actual_demand);%9：实际需水量
        flow_reservoir_2(new_reservoirs_num) = node_actual_demand;
    end
    damage_pipe(new_reservoirs_num).id = damage_pipe_id;
    damage_pipe(new_reservoirs_num).leak_demand = [flow_reservoir_1(new_reservoirs_num)+flow_reservoir_2(new_reservoirs_num),flow_reservoir_1(new_reservoirs_num),flow_reservoir_2(new_reservoirs_num)];
end

errcode7_4 = calllib(lib_name,'ENclose');
damage_pipe_leak_table = struct2table(damage_pipe);
leak_demand_max = max(damage_pipe_leak_table.leak_demand(:,1));
damage_pipe_leak_table.leak_demand_relative = damage_pipe_leak_table.leak_demand(:,1)/leak_demand_max;
damage_pipe_leak_table.hyduralicImportanc = hydraulic_importance(damage_pipe_info{1})';
damage_pipe_leak_table.hyduralicImportancRelative = hydraulic_importance_relative(damage_pipe_info{1})';
damage_pipe_leak_table.loc = damage_pipe_info{1};
damage_pipe_leak_table.damageType(damage_pipe_info{3}==2)= {'break'};
damage_pipe_leak_table.damageType(damage_pipe_info{3}==1)= {'leak'};
damage_pipe_leak_table.isolationTime(damage_pipe_info{3}==2) = isolation_time_mat;
damage_pipe_leak_table.isolationTime(damage_pipe_info{3}==1) = 0;
damage_pipe_leak_table.isolationTimeRelative(damage_pipe_info{3}==2) = isolation_time_relative_mat;
damage_pipe_leak_table.isolationTimeRelative(damage_pipe_info{3}==1) = 0;
damage_pipe_leak_table.recoveryTime = recovery_time_mat;
damage_pipe_leak_table.recoveryTimeRelative = recovery_time_relative_mat;
damage_pipe_leak_table.isolateCoefficient(damage_pipe_info{3}==2) = damage_pipe_leak_table.hyduralicImportancRelative(damage_pipe_info{3}==2).*damage_pipe_leak_table.leak_demand_relative(damage_pipe_info{3}==2)./damage_pipe_leak_table.isolationTimeRelative(damage_pipe_info{3}==2);

damage_pipe_leak_table.recoveryCoefficient =damage_pipe_leak_table.hyduralicImportancRelative.*damage_pipe_leak_table.leak_demand_relative./damage_pipe_leak_table.recoveryTimeRelative;

global n_ENrun
n_ENrun = 0 ;
n1 = n_ENrun;
% process_7
priority = struct('serviceability',[],'resilience_mean_serviceability',[],'resilience_mean_recovery_rate',[],'ENrun_num',[]);
% keyboard

% 确定次序
% [ best_indivi_isolation_1,best_indivi_recovery_1,best_indivi_isolation_1_id,best_indivi_recovery_1_id ] = hydralicImpotance_priority( damage_pipe_info,net_data );
tblA = damage_pipe_leak_table(damage_pipe_info{3}==2,:);
tblB = sortrows(tblA ,'isolateCoefficient','descend');
best_indivi_isolation_1 = tblB.loc';
best_indivi_isolation_1_id = tblB.id';
tblC = sortrows(damage_pipe_leak_table,'recoveryCoefficient','descend');
best_indivi_recovery_1 = tblC.loc';
best_indivi_recovery_1_id = tblC.id';
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
save(['test_adjuxt_hydraulic_',damage_info_file_name(1:end-4)],'priority_hydraulicImportance');
sum(priority_hydraulicImportance.calculate_code~=0)
numel(priority_hydraulicImportance.calculate_code)
