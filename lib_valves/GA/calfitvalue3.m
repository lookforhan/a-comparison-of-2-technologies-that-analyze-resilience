% 2018-11-15；韩朝；重新修改，将隔离和修复工作分开。并且使用EPANETx64PDD,因此不在需要编写PDD相关的程序。
% 2018-01-01；韩朝：增加案例说明的注释，计算检查次序和修复次序的适应度值
%% 韩朝 hanzhao@emails.bjut.edu.cn
%% 2017-12-19
%% 计算初始种群中每个个体的适应度值
% pop,为种群
% fivalue,为种群中个体对应的适应度值,按照适应度值大小排序
% 案例
%{
pop={'1';'2';'3';'2';'3';'1',};%种群
RepairCrew={'a';'b'};%修复队伍
BreakPipe_order={'1';'2';'3'};%管道顺序
Dp_Inspect_mat=[2;3;5];%检查时间矩阵
Dp_Repair_mat=[6;7;8];%修复时间矩阵
,Dp_Travel_mat=[0,2,3;2,0,2;3,2,0];%移动时间矩阵
MC_i=1;%当前Monte Carlo模拟次数；fit2.m函数的输入参数；disp输出的参数
original_junction_num=%节点个数；fit2.m函数的输入参数
damage_pipe_info=%管道破坏信息；fit2.m函数的输入参数
net_data,MC_simulate_result_dir,...；fit2.m函数的输入参数
     EPA_format,node_original_data,circulation_num,doa,Hmin,Hdes,node_original_dem,system_original_L,generation_dir_i,generation_i；fit2.m函数的输入参数
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
    pipe_relative)%评价种群个体适应度

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