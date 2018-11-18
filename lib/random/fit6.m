% 2018-11-15；韩朝；基于fit4.m和EPANETx64PDD.dll完成
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
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel)%评价种群个体适应度
funcName = 'fit6';

% BreakPipe_InspectPriority=BreakPipePriority(1:n/2);
% BreakPipe_RepairPriority=BreakPipePriority(n/2+1:end);
BreakPipePriority_cell = num2cell(BreakPipePriority');
DamagePipePriority_cell = num2cell(BreakPipe_order);
[BreakPipe_result,RepairCrew_result]=priorityList2schedule9(BreakPipePriority_cell,DamagePipePriority_cell,RepairCrew,DamagePipePriority_cell,...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,output_result_dir,...
     crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel);%根据修复次序生成时间表，隔离与修复分开的策略 from 'random\'

[PipeStatus2,PipeStatusChange]=schedule2pipestatus4(BreakPipe_result);%根据时间表生成管道状态矩阵
if isempty(PipeStatus2)
    PipeStatus = ones(numel(BreakPipe_order),168*2)*2;%没有修复的延时模拟过程。
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
% 后处理

end