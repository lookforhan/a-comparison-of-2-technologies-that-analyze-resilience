function [ best_indivi_isolation_1,best_indivi_recovery_1,best_indivi_isolation_1_id,best_indivi_recovery_1_id] = straightLineImportance_priority(damage_pipe_info,net_data,Dp_Inspect_mat,Dp_Repair_mat )
%recoveryImportance_priority 此处显示有关此函数的摘要
%   此处显示详细说明
best_indivi_isolation_1_cell =damage_pipe_info{5}(damage_pipe_info{3}==2);
best_indivi_recovery_1_2_cell = damage_pipe_info{5}(damage_pipe_info{3}==1);
% [~,midd_ia] = ismember( best_indivi_recovery_1_2_cell,net_data{5,2}(:,1));
% [~,~,ic] = unique(midd_ia);
% theChosenIndex1 = hydraulicIndex(midd_ia);
% theChosenIndex_recovery =theChosenIndex1;
% theChosenIndex_isolation = theChosenIndex1(damage_pipe_info{3}==2);
mid = PipeSort(net_data,best_indivi_isolation_1_cell);
mid.SortStraightLineDistance2Reservoirs;%按照到水源距离从小到大排序
best_indivi_isolation_1_id = mid.sortPipeID;
best_indivi_isolation_1 = cell2mat(mid.sortPipeLocb)';
mid.delete
mid = PipeSort(net_data,best_indivi_recovery_1_2_cell);
mid.SortStraightLineDistance2Reservoirs;%按照到水源距离从小到大排序
best_indivi_recovery_1_id = [best_indivi_isolation_1_id;mid.sortPipeID];
best_indivi_recovery_1_2 = cell2mat(mid.sortPipeLocb)';
best_indivi_recovery_1 = [best_indivi_isolation_1,best_indivi_recovery_1_2];
mid.delete

end

