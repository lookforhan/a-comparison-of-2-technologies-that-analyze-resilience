% 2018-11-15������������fit4.m��EPANETx64PDD.dll���
% 2018-2-5�����������ӻ�ͼ��������ɢ��ͼ�����������Լ�ƽ����������һ��
% 2018-1-16;�������������F,system_L,system_serviceability,node2_serviceability
%2018-1-18;���������Ӽ��غ�ж�ض�̬���ӿ��������ڶ�̬���ӿⱾ������⵱��ε��ú����ֲ���Ԥ��Ĵ���
% 2018-1-3;�������ر����õ����
% 2018-1-1;���������ӹܵ����͹رչܵ�����
% 2018-5-20;����:ʹ��epanet2.dll�Դ���ʱ�䲽���㺯����
%% 2017-12-19
%% ���� hanzhao@emails.bjut.edu.cn
%% Ϊ��������룬���Ŵ��㷨�м�����Ӧ�Ⱥ������ִ�������
%% ����
% BreakPipePriority���ܵ��޸������Ż�����
% RepairCrew,�޸�������
% BreakPipe_order,�ܵ��ƻ���Ϣ�洢˳��
% MC_i�����ؿ���ģ�����
% generation_i,�Ż���������
% individual_i,������
% original_junction_num������ԭʼ�ڵ���Ŀ
% damage_pipe_info,�ܵ��ƻ���Ϣ
% MC_simulate_result_dir�����ؿ���ģ�����洢�ļ���
% individual_dir_i,����������ļ���
% EPA_format,inpˮ��ģ���ļ���ʽ
% node_original_data�������ڵ�ԭʼ����
% circulation_num��PDDˮ����������������
% doa,PDDˮ�����㾫��
% Hmin,PDDˮ���������ˮѹ
% Hdes,PDDˮ����������ˮѹ
% node_original_dem,�����ڵ�ԭʼ��ˮ��
% system_original_L�������ܵ�����ԭʼ����
%% ���
%Fitness ��Ӧ�Ⱥ���
% BreakPipe_result,(nB,4), ��¼��1�ƻ��ܵ����\2�޸���ʼʱ��\3�޸�����ʱ��\4ά�޶�����
% RepairCrew_result,(RN,3),��¼��1ά�޶�����\2ά���˹ܵ�����\3ƽ���޸�ʱ��
% F,��¼ϵͳ��̬��ʱ�̱仯
% system_L,��¼�ܵ��������ȵ�ʱ�̱仯
% system_serviceability,��¼ϵͳ��ˮ�����ʵ�ʱ�̱仯
% node2_serviceability��
function [Fitness,...
    BreakPipe_result,...
    RepairCrew_result,...
    system_serviceability_cell,...
    activity_cell]...
    =fit6...
    (BreakPipePriority,...
    BreakPipe_order,RepairCrew,...
    Dp_Inspect_mat,...
    Dp_Repair_mat,Dp_Travel_mat,...
    net_data,...
    output_result_dir,...
    output_net_filename_inp,...
    pipe_relative,...
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel)%������Ⱥ������Ӧ��
funcName = 'fit6';

% BreakPipe_InspectPriority=BreakPipePriority(1:n/2);
% BreakPipe_RepairPriority=BreakPipePriority(n/2+1:end);
BreakPipePriority_cell = num2cell(BreakPipePriority');
DamagePipePriority_cell = num2cell(BreakPipe_order);
[BreakPipe_result,RepairCrew_result]=priorityList2schedule9(BreakPipePriority_cell,DamagePipePriority_cell,RepairCrew,DamagePipePriority_cell,...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,output_result_dir,...
     crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel);%�����޸���������ʱ����������޸��ֿ��Ĳ��� from 'random\'

[PipeStatus2,PipeStatusChange]=schedule2pipestatus4(BreakPipe_result);%����ʱ������ɹܵ�״̬����
if isempty(PipeStatus2)
    PipeStatus = ones(numel(BreakPipe_order),168*2)*2;%û���޸�����ʱģ����̡�
else
    PipeStatus = PipeStatus2;
end
duration_one = numel(PipeStatus(1,:));
% disp([funcName,'-',num2str(duration_one)]);
% [ errcode,Pressure,Demand,Length,system_L_cell,system_serviceability_cell,node_serviceability_cell,timeStep_cell,activity_cell] = EPS_net3( output_net_filename_inp,output_result_dir,PipeStatus,PipeStatusChange,pipe_relative,net_data,...
%     circulation_num,doa,Hmin,Hdes,duration_one);
 [ errcode,Pre,Demand,cal_Demand, system_serviceability_cell,activity_cell] = EPS_net4_EPANETx64PDD( output_net_filename_inp,output_result_dir,PipeStatus,PipeStatusChange,pipe_relative,net_data,...
    duration_one);
Fitness = sum(cell2mat(system_serviceability_cell))/duration_one;
% timeStep_end=0;
% ����

end