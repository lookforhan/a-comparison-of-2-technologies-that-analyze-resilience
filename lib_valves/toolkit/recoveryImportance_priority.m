function [ best_indivi_isolation_1,best_indivi_recovery_1,best_indivi_isolation_1_id,best_indivi_recovery_1_id] = recoveryImportance_priority(damage_pipe_info,net_data,Dp_Inspect_mat,Dp_Repair_mat )
%recoveryImportance_priority �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
load('data2.mat')% ˮ����Ҫ��
best_indivi_isolation_1_cell =damage_pipe_info{5}(damage_pipe_info{3}==2);
best_indivi_recovery_1_cell = damage_pipe_info{5};
[~,midd_ia] = ismember( best_indivi_recovery_1_cell,net_data{5,2}(:,1));
% [~,~,ic] = unique(midd_ia);
theChosenIndex1 = hydraulicIndex(midd_ia);
theChosenIndex_recovery =theChosenIndex1./Dp_Repair_mat;
theChosenIndex_isolation = theChosenIndex1(damage_pipe_info{3}==2)./Dp_Inspect_mat(damage_pipe_info{3}==2);
% ����
mid = PipeSort(net_data,best_indivi_isolation_1_cell);
mid.SortIndex_high2low(num2cell(theChosenIndex_isolation))
best_indivi_isolation_1_id = mid.sortPipeID;
best_indivi_isolation_1 = cell2mat(mid.sortPipeLocb)';
mid.delete
% �޸�
mid = PipeSort(net_data,best_indivi_recovery_1_cell);
mid.SortIndex_high2low(num2cell(theChosenIndex_recovery))
best_indivi_recovery_1_id = [mid.sortPipeID];
best_indivi_recovery_1 = cell2mat(mid.sortPipeLocb)';

mid.delete

end

