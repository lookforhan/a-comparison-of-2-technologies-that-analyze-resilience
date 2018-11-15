% 2018-1-1；韩朝：初始种群中包括管道检查次序
%% 韩朝 hanzhao@emails.bjut.edu.cn
%% 2017-12-19
% initpop.m函数的功能是实现群体的初始化，popsize表示群体的大小，chromlength表示染色体的长度(二值数的长度)，
% 长度大小取决于变量的二进制编码的长度(在本例中取10位)。
%遗传算法子程序
%Name: initpop.m
%初始化种群
% pop=initpop2(20,{1;4;2;3;5})
function [pop_isolation_init,pop_replacement_init]=initpop3(popsize,Pipe_isolation,Pipe_replacement)
pop_isolation_init=cell(popsize,1);%第一列为管道检查次序
pop_replacement_init=cell(popsize,1);%第一列为管道修复次序
for i=1:popsize
[pop_isolation_init{i,1}]=pipeDamage2priorityList2(Pipe_isolation);%随机生成检查次序
[pop_replacement_init{i,1}]=pipeDamage2priorityList2(Pipe_replacement);%随机生成修复次序
end
end