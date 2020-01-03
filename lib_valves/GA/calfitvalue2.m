% 2018-01-01�����������Ӱ���˵����ע�ͣ������������޸��������Ӧ��ֵ
%% ���� hanzhao@emails.bjut.edu.cn
%% 2017-12-19
%% �����ʼ��Ⱥ��ÿ���������Ӧ��ֵ
% pop,Ϊ��Ⱥ
% fivalue,Ϊ��Ⱥ�и����Ӧ����Ӧ��ֵ,������Ӧ��ֵ��С����
% ����
%{
pop={'1';'2';'3';'2';'3';'1',};%��Ⱥ
RepairCrew={'a';'b'};%�޸�����
BreakPipe_order={'1';'2';'3'};%�ܵ�˳��
Dp_Inspect_mat=[2;3;5];%���ʱ�����
Dp_Repair_mat=[6;7;8];%�޸�ʱ�����
,Dp_Travel_mat=[0,2,3;2,0,2;3,2,0];%�ƶ�ʱ�����
MC_i=1;%��ǰMonte Carloģ�������fit2.m���������������disp����Ĳ���
original_junction_num=%�ڵ������fit2.m�������������
damage_pipe_info=%�ܵ��ƻ���Ϣ��fit2.m�������������
net_data,MC_simulate_result_dir,...��fit2.m�������������
     EPA_format,node_original_data,circulation_num,doa,Hmin,Hdes,node_original_dem,system_original_L,generation_dir_i,generation_i��fit2.m�������������
 [fitvalue_sort,best_pop]=calfitvalue(pop,RepairCrew,BreakPipe_order,...
      Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
     MC_i,original_junction_num,damage_pipe_info,net_data,MC_simulate_result_dir,...
     EPA_format,node_original_data,circulation_num,doa,Hmin,Hdes,node_original_dem,system_original_L,generation_dir_i,generation_i)
%}
function [Fit,fitvalue]=calfitvalue2(pop,RepairCrew,BreakPipe_order,...
     Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
    MC_i,...original_junction_num,
    damage_pipe_info,net_data,MC_simulate_result_dir,...
    EPA_format,...node_original_data,
    circulation_num,doa,Hmin,Hdes,...node_original_dem,system_original_L,
    generation_dir_i,generation_i,...
output_net_filename_inp,pipe_relative)%,...
%     pressure_cell,demand_cell)
popsize=numel(pop);
fitvalue=cell(popsize,15);
% pipe_relative = damage_pipe_info{1,5};
for individual_i=1:popsize
%     disp(['calfitvalue','��',num2str(MC_i),'ģ�⣻','�Ŵ���',num2str(generation_i),'����','����',num2str(individual_i),'/',num2str(popsize)])
%     disp(['��',num2str(MC_i),'ģ��','�Ŵ���',num2str(generation_i),'��','����',num2str(individual_i)])
    individual_dir_i=[generation_dir_i,'\',num2str(individual_i),'\'];
    mkdir(individual_dir_i)
    BreakPipePriority=pop{individual_i};
    %fit4 
    [Fitness,BreakPipe_result,RepairCrew_result,...
        F,...
    system_L,...
    system_serviceability,...
    node_serviceability,...
    node2_serviceability,...
    node_calculate_dem,...
    node_calculate_pre,...
    timeStep_end,timeStep,activity_cell...
        ]=fit4...
    (BreakPipePriority,...
    RepairCrew,BreakPipe_order,...
    Dp_Inspect_mat,...
    Dp_Repair_mat,Dp_Travel_mat,...original_junction_num,...
    damage_pipe_info,...
    net_data,...
    MC_i,...
    generation_i,...
    individual_i,...
    MC_simulate_result_dir,...
    generation_dir_i,...
    individual_dir_i,...
    EPA_format,...node_original_data,...
    circulation_num,...
    doa,...
    Hmin,...
    Hdes,...node_original_dem,system_original_L,...
    output_net_filename_inp,...
    pipe_relative,'off');%������Ⱥ������Ӧ��

    fitvalue{individual_i,1}=Fitness;
    fitvalue{individual_i,2}=BreakPipe_result;
    fitvalue{individual_i,3}=RepairCrew_result;
    fitvalue{individual_i,4}=BreakPipePriority;
    fitvalue{individual_i,5}=F;
    fitvalue{individual_i,6}=system_L;
    fitvalue{individual_i,7}=system_serviceability;
    fitvalue{individual_i,8}=node_serviceability;
    fitvalue{individual_i,9}=node2_serviceability;
    fitvalue{individual_i,10}=node_calculate_dem;
    fitvalue{individual_i,11}=node_calculate_pre;
    fitvalue{individual_i,12}=timeStep_end;
    fitvalue{individual_i,13}=timeStep;
    fitvalue{individual_i,14}=activity_cell;
    fitvalue{individual_i,15}=individual_i;
end
disp(['��',num2str(MC_i),'ģ��','�Ŵ���',num2str(generation_i),'��'])

Fit = fitvalue(:,1);
end