% 2018-1-1；韩朝：初始种群中包括管道检查次序
%% 韩朝 hanzhao@emails.bjut.edu.cn
%% 2017-12-19
% initpop.m函数的功能是实现群体的初始化，popsize表示群体的大小，
% 长度大小取决于变量的二进制编码的长度(在本例中取10位)。
%遗传算法子程序
%Name: initpop.m
%初始化
% popsize 种群大小，
% BreakPipe_order 破坏管道
function pop=initpop(popsize,BreakPipe_order)
pop=cell(popsize,1);%检查和修复次序合一
for i=1:popsize
[pop{i,1}]=pipeDamage2priorityList(BreakPipe_order);%生成修复次序
end
end