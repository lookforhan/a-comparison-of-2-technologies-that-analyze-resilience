% 2018-1-1；韩朝：增加注释
%% 2017-12-18
%% 韩朝
%% 根据破坏信息生成管道修复次序
%% 调试阶段先随机生成管道次序
% BreakPipe_order 元胞数组
function [BreakPipePriority]=pipeDamage2priorityList(BreakPipe_order)
n=numel(BreakPipe_order);%计算破坏管道个数
priority=randperm(n)';%产生随机次序
priority_1=num2cell(priority);%将矩阵转化为元胞数组
priority_2=[priority_1,BreakPipe_order];%合并为两列元胞数组
BreakPipePriority_1=sortrows(priority_2);%按随机priority_1次序排序
BreakPipePriority_1(:,1)=[];%删除次序列priority_1
BreakPipePriority=BreakPipePriority_1;%输出结果为元胞数组

end