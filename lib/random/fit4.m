% 2018-2-5；韩朝：增加画图：将韧性散点图、最优韧性以及平均韧性三合一。
% 2018-1-16;韩朝：增加输出F,system_L,system_serviceability,node2_serviceability
%2018-1-18;韩朝：增加加载和卸载动态链接库的命令，由于动态链接库本身的问题当多次调用后会出现不可预测的错误
% 2018-1-3;韩朝：关闭无用的输出
% 2018-1-1;韩朝：增加管道检查和关闭管道过程
% 2018-5-20;韩朝:使用epanet2.dll自带的时间步计算函数。
%% 2017-12-19
%% 韩朝 hanzhao@emails.bjut.edu.cn
%% 为了梳理代码，将遗传算法中计算适应度函数部分代码整合
%% 输入
% BreakPipePriority，管道修复次序，优化变量
% RepairCrew,修复队伍编号
% BreakPipe_order,管道破坏信息存储顺序
% MC_i，蒙特卡罗模拟次数
% generation_i,优化代数次数
% individual_i,个体数
% original_junction_num，管网原始节点数目
% damage_pipe_info,管道破坏信息
% MC_simulate_result_dir，蒙特卡罗模拟结果存储文件夹
% individual_dir_i,个体计算结果文件夹
% EPA_format,inp水力模型文件格式
% node_original_data，管网节点原始数据
% circulation_num，PDD水力分析最大迭代次数
% doa,PDD水力计算精度
% Hmin,PDD水力计算最低水压
% Hdes,PDD水力计算满足水压
% node_original_dem,管网节点原始需水量
% system_original_L，管网管道运行原始长度
%% 输出
%Fitness 适应度函数
% BreakPipe_result,(nB,4), 记录：1破坏管道编号\2修复开始时间\3修复结束时间\4维修队伍编号
% RepairCrew_result,(RN,3),记录：1维修队伍编号\2维修了管道个数\3平均修复时间
% F,记录系统性态的时程变化
% system_L,记录管道工作长度的时程变化
% system_serviceability,记录系统供水满意率的时程变化
% node2_serviceability，
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
    pipe_relative,plot_keyword)%评价种群个体适应度
funcName = 'fit4';
n=numel(BreakPipePriority);
% BreakPipe_InspectPriority=BreakPipePriority(1:n/2);
% BreakPipe_RepairPriority=BreakPipePriority(n/2+1:end);
[BreakPipe_result,RepairCrew_result]=priorityList2schedule6(BreakPipePriority,RepairCrew,BreakPipe_order,...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,output_result_dir);%根据修复次序生成时间表

[PipeStatus2,PipeStatusChange]=schedule2pipestatus3(BreakPipe_result);%根据时间表生成管道状态矩阵
if isempty(PipeStatus2)
    PipeStatus = ones(numel(BreakPipe_order),168*2)*2;%没有修复的延时模拟过程。
else
    PipeStatus = PipeStatus2;
end
duration_one = numel(PipeStatus(1,:));
% disp([funcName,'-',num2str(duration_one)]);
[ errcode,Pressure,Demand,Length,system_L_cell,system_serviceability_cell,node_serviceability_cell,timeStep_cell,activity_cell] = EPS_net3( output_net_filename_inp,output_result_dir,PipeStatus,PipeStatusChange,pipe_relative,net_data,...
    circulation_num,doa,Hmin,Hdes,duration_one);
if errcode ~= 0
    disp('errors==================');
    disp([funcName,'错误']);
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
ii  = rem(timeStep2,1)==0;%为整数的点，即整小时的时刻
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
% 后处理
if false

    n_node = numel(Pressure{1});
    node_id = net_data{2,2}(:,1);
    node_data = cell(n_node+2,1);
    for i = 1:numel(Pressure)
        p = [timeStep_cell(i);{'压力'};num2cell(Pressure{i})];
        d = [timeStep_cell(i);{'需水量'};num2cell(Demand{i})];
        node_data = [node_data,p,d];
    end
    node_data (:,1)=[];
    node_data = [[{'时间'};{'节点id'};node_id],node_data];
    xlswrite('fit4-1.xls',node_data');
end
end