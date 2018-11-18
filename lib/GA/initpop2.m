% 2018-1-1；韩朝：初始种群中包括管道检查次序
%% 韩朝 hanzhao@emails.bjut.edu.cn
%% 2017-12-19
% initpop.m函数的功能是实现群体的初始化，popsize表示群体的大小，chromlength表示染色体的长度(二值数的长度)，
% 长度大小取决于变量的二进制编码的长度(在本例中取10位)。
%遗传算法子程序
%Name: initpop.m
%初始化种群
% pop=initpop2(20,{1;4;2;3;5})
function pop=initpop2(popsize,BreakPipe_order)
pop=cell(popsize,1);%第一列为管道检查次序，第2列为管道修复次序
pop1=cell(popsize,2);%第一列为管道检查次序，第2列为管道修复次序
for i=1:popsize
[pop1{i,1}]=pipeDamage2priorityList(BreakPipe_order);%随机生成检查次序
[pop1{i,2}]=pipeDamage2priorityList(BreakPipe_order);%随机生成修复次序
pop{i}=[pop1{i,1};pop1{i,2}];%将次序合并
end
end