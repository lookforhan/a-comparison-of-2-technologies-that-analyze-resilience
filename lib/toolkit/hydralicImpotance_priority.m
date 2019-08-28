function [ best_indivi_isolation_1,best_indivi_recovery_1,best_indivi_isolation_1_id,best_indivi_recovery_1_id ] = hydralicImpotance_priority( damage_pipe_info,net_data )
%hydralicImpotance_priority 此处显示有关此函数的摘要
%   data2.mat中保存的变量为hydraulicIndex，管道的水力重要度，按照管道编号排序。
load('data2.mat')%
best_indivi_isolation_1_cell =damage_pipe_info{5}(damage_pipe_info{3}==2);
best_indivi_recovery_1_cell = damage_pipe_info{5};
[~,midd_ia] = ismember( best_indivi_recovery_1_cell,net_data{5,2}(:,1));
% [~,~,ic] = unique(midd_ia);
theChosenIndex1 = hydraulicIndex(midd_ia);
theChosenIndex_recovery =theChosenIndex1;
theChosenIndex_isolation = theChosenIndex1(damage_pipe_info{3}==2);
mid = PipeSort(net_data,best_indivi_isolation_1_cell);
mid.SortIndex_high2low(num2cell(theChosenIndex_isolation));
best_indivi_isolation_1_id = mid.sortPipeID;
best_indivi_isolation_1 = cell2mat(mid.sortPipeLocb)';
mid.delete
mid = PipeSort(net_data,best_indivi_recovery_1_cell);
mid.SortIndex_high2low(num2cell(theChosenIndex_recovery));
best_indivi_recovery_1_id = mid.sortPipeID;
best_indivi_recovery_1 = cell2mat(mid.sortPipeLocb)';
mid.delete

end

