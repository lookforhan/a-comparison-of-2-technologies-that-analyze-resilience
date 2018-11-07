function [ newPop ] = ga_process( pop,fit,pm,pc )
%ga_process 遗传算法操作
%   输入：pop原种群
%   输入：fit原种群适应度
%   输入：pm变异概率
%   输入：pc交叉概率
%   输出：新种群
%   方法：选择、交叉、变异、精英保留
Fitvalue=linear_normalized(fit,100,2.5);%归一化
 [newpop_section,best_indiv]=selection2(pop,Fitvalue);%% 选择
 [newpop_cross,record_cross]=crossover5(newpop_section,pc);%交配
 [newpop_mutation,record_mutation]=mutation2(newpop_cross,pm);%变异
 newPop = [newpop_mutation;best_indiv;best_indiv];
end

