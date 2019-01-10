function [ best_indivi_isolation_1,best_indivi_recovery_1,best_indivi_isolation_1_id,best_indivi_recovery_1_id] = straightLineImportance_priority(damage_pipe_info,net_data,Dp_Inspect_mat,Dp_Repair_mat )
%recoveryImportance_priority �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
best_indivi_isolation_1_cell =damage_pipe_info{5}(damage_pipe_info{3}==2);
best_indivi_recovery_1_2_cell = damage_pipe_info{5}(damage_pipe_info{3}==1);
% [~,midd_ia] = ismember( best_indivi_recovery_1_2_cell,net_data{5,2}(:,1));
% [~,~,ic] = unique(midd_ia);
% theChosenIndex1 = hydraulicIndex(midd_ia);
% theChosenIndex_recovery =theChosenIndex1;
% theChosenIndex_isolation = theChosenIndex1(damage_pipe_info{3}==2);
mid = PipeSort(net_data,best_indivi_isolation_1_cell);
mid.SortStraightLineDistance2Reservoirs;%���յ�ˮԴ�����С��������
best_indivi_isolation_1_id = mid.sortPipeID;
best_indivi_isolation_1 = cell2mat(mid.sortPipeLocb)';
mid.delete
mid = PipeSort(net_data,best_indivi_recovery_1_2_cell);
mid.SortStraightLineDistance2Reservoirs;%���յ�ˮԴ�����С��������
best_indivi_recovery_1_id = [best_indivi_isolation_1_id;mid.sortPipeID];
best_indivi_recovery_1_2 = cell2mat(mid.sortPipeLocb)';
best_indivi_recovery_1 = [best_indivi_isolation_1,best_indivi_recovery_1_2];
mid.delete

end

