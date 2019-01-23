function [Fitness,...
    BreakPipe_result,...
    RepairCrew_result,...
    system_serviceability_cell,...
    activity_cell,results,schedule]...
    =fit8_recovery...
    (indivi_isolation,BreakPipeRecoveryPriority,...
    BreakPipe_order,RepairCrew,...
    Dp_Inspect_mat,...
    Dp_Repair_mat,Dp_Travel_mat,...
    net_data,...
    output_result_dir,...
    output_net_filename_inp,...
    pipe_relative,...
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel)%������Ⱥ������Ӧ��
funcName = mfilename;
disp(funcName)
BreakPipePriority_cell = num2cell(indivi_isolation');
DamagePipePriority_cell = num2cell(BreakPipeRecoveryPriority');
[BreakPipe_result,RepairCrew_result,Active_result]=priorityList2schedule9(BreakPipePriority_cell,DamagePipePriority_cell,RepairCrew,num2cell(BreakPipe_order),...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,output_result_dir,...
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel);%�����޸���������ʱ������������޸��ֿ��Ĳ��� from 'random\'
t = Schedule(Active_result,BreakPipe_result);
t.crew_origin = RepairCrew;
t.pipe_origin = net_data{5,2}(:,1);
t.Run
PipeStatus = t.time_schedule_pipeStatus';
PipeStatusChange = t.time_schedule_pipeStatusChange';
schedule = t;
% t.delete
duration_one = numel(PipeStatus(1,:));
a = EPS_net_EPANETx64PDD( output_net_filename_inp,output_result_dir,PipeStatus,PipeStatusChange,pipe_relative,net_data,...
    duration_one);
a.Run_debug;
system_serviceability_cell = a.system_serviceability;
activity_cell = a.activity;
results = a;
% a.delete
Fitness = sum(cell2mat(system_serviceability_cell))/duration_one;
end
