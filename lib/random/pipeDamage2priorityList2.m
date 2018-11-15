% 20a8-11-15;韩朝
% 2018-1-1；韩朝：增加注释
%% 2017-12-18
%% 韩朝
%% 根据破坏信息生成管道修复次序
%% 调试阶段先随机生成管道次序
% BreakPipe_order 元胞数组
function [BreakPipePriority]=pipeDamage2priorityList2(BreakPipe_order)
n=numel(BreakPipe_order);%计算破坏管道个数
priority=randperm(n)';%产生随机次序
BreakPipePriority_1 = BreakPipe_order(priority);
BreakPipePriority=BreakPipePriority_1;%输出结果为元胞数组

end