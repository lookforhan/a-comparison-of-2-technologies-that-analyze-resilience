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
    F,...
    system_L,...
    system_serviceability,...
    node_serviceability,...
    node2_serviceability,...
    node_calculate_dem,...
    node_calculate_pre,...
    timeStep_end,timeStep,activity_cell]...
    =fit4...
    (BreakPipePriority,...
    RepairCrew,BreakPipe_order,...
    Dp_Inspect_mat,...
    Dp_Repair_mat,Dp_Travel_mat,...original_junction_num,...
    damage_pipe_info,...
    net_data,...
    MC_i,...
    generation_i,...
    individual_i,...
    output_result_dir_no,...
    generation_dir_i,...
    output_result_dir,...
    EPA_format,...node_original_data,...
    circulation_num,...
    doa,...
    Hmin,...
    Hdes,...node_original_dem,system_original_L,...
    output_net_filename_inp,...
    pipe_relative,plot_keyword)%������Ⱥ������Ӧ��
funcName = 'fit4';
n=numel(BreakPipePriority);
% BreakPipe_InspectPriority=BreakPipePriority(1:n/2);
% BreakPipe_RepairPriority=BreakPipePriority(n/2+1:end);
[BreakPipe_result,RepairCrew_result]=priorityList2schedule6(BreakPipePriority,RepairCrew,BreakPipe_order,...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,output_result_dir);%�����޸���������ʱ���

[PipeStatus2,PipeStatusChange]=schedule2pipestatus3(BreakPipe_result);%����ʱ������ɹܵ�״̬����
if isempty(PipeStatus2)
    PipeStatus = ones(numel(BreakPipe_order),168*2)*2;%û���޸�����ʱģ����̡�
else
    PipeStatus = PipeStatus2;
end
duration_one = numel(PipeStatus(1,:));
% disp([funcName,'-',num2str(duration_one)]);
[ errcode,Pressure,Demand,Length,system_L_cell,system_serviceability_cell,node_serviceability_cell,timeStep_cell,activity_cell] = EPS_net3( output_net_filename_inp,output_result_dir,PipeStatus,PipeStatusChange,pipe_relative,net_data,...
    circulation_num,doa,Hmin,Hdes,duration_one);
if errcode ~= 0
    disp('errors==================');
    disp([funcName,'����']);
    disp("[ Pressure,Demand,Length,system_L_cell,system_serviceability_cell,node_serviceability_cell] = EPS_net2( output_net_filename_inp,MC_simulate_result_dir,PipeStatus,pipe_relative,net_data,circulation_num,doa,Hmin,Hdes,duration_one)")
    %     disp(num2str(c));
    timeStep_end = numel(PipeStatus(1,:));
    system_L=0;
    system_serviceability=0;
    node_serviceability=0;
    F=0;
    F_resiliencd=sum(F);
    Fitness = 0;
    node2_serviceability=0;
    node_calculate_dem=0;
    node_calculate_pre=0;
    % timeStep_end=0;
    return
end

w1=0.5;
w2=0.5;
timeStep_end = numel(PipeStatus(1,:));
timeStep = cell2mat(timeStep_cell);
timeStep2 = timeStep./3600;
ii  = rem(timeStep2,1)==0;%Ϊ�����ĵ㣬����Сʱ��ʱ��
system_L=cell2mat(system_L_cell);
system_serviceability=cell2mat(system_serviceability_cell);
node_serviceability=cell2mat(node_serviceability_cell);
F=w1*system_serviceability+w2*system_L;
F_resiliencd=sum(F(ii));
Fitness = F_resiliencd/timeStep_end;
node2_serviceability=0;
node_calculate_dem=0;
node_calculate_pre=0;
% timeStep_end=0;
% ����
if false

    n_node = numel(Pressure{1});
    node_id = net_data{2,2}(:,1);
    node_data = cell(n_node+2,1);
    for i = 1:numel(Pressure)
        p = [timeStep_cell(i);{'ѹ��'};num2cell(Pressure{i})];
        d = [timeStep_cell(i);{'��ˮ��'};num2cell(Demand{i})];
        node_data = [node_data,p,d];
    end
    node_data (:,1)=[];
    node_data = [[{'ʱ��'};{'�ڵ�id'};node_id],node_data];
    xlswrite('fit4-1.xls',node_data');
end
end