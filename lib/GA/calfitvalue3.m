% 2018-11-15�������������޸ģ���������޸������ֿ�������ʹ��EPANETx64PDD,��˲�����Ҫ��дPDD��صĳ���
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
function [Fit,fitvalue]=calfitvalue3(pop,BreakPipe_order,RepairCrew,...
     Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
    ~,net_data,...
    ~,...
    generation_dir_i,...
output_net_filename_inp,pipe_relative)%,...

popsize = numel(pop(:,1));
Fitness= zeros(popsize,1);
fitvalue=cell(popsize,15);
for individual_i=1:popsize
    individual_dir_i=[generation_dir_i,'\',num2str(individual_i),'\'];
    mkdir(individual_dir_i)
    BreakPipePriority=pop(individual_i,:);
    %fit5
    [Fitness(individual_i),...
    BreakPipe_result,...
    RepairCrew_result,...
    system_serviceability_cell,...
    activity_cell]...
    =fit5...
    (BreakPipePriority,...
    BreakPipe_order,RepairCrew,...
    Dp_Inspect_mat,...
    Dp_Repair_mat,Dp_Travel_mat,...
    net_data,...
    individual_dir_i,...
    output_net_filename_inp,...
    pipe_relative)%������Ⱥ������Ӧ��

%     fitvalue{individual_i,1}=Fitness;
%     fitvalue{individual_i,2}=BreakPipe_result;
%     fitvalue{individual_i,3}=RepairCrew_result;
%     fitvalue{individual_i,4}=BreakPipePriority;
%     fitvalue{individual_i,5}=F;
%     fitvalue{individual_i,6}=system_L;
%     fitvalue{individual_i,7}=system_serviceability;
%     fitvalue{individual_i,8}=node_serviceability;
%     fitvalue{individual_i,9}=node2_serviceability;
%     fitvalue{individual_i,10}=node_calculate_dem;
%     fitvalue{individual_i,11}=node_calculate_pre;
%     fitvalue{individual_i,12}=timeStep_end;
%     fitvalue{individual_i,13}=timeStep;
%     fitvalue{individual_i,14}=activity_cell;
%     fitvalue{individual_i,15}=individual_i;
end


Fit = Fitness;
end