function [ best_indivi_isolation_1,best_indivi_recovery_1,best_indivi_isolation_1_id,best_indivi_recovery_1_id] = greedyImportance_priority(damage_pipe_info,net_data,Dp_Inspect_mat,Dp_Repair_mat,temp_inp_file,pipe_relative )
%recoveryImportance_priority 此处显示有关此函数的摘要
%   (系统供水满足率/时间)提高最快的次序
break_pipe_id = damage_pipe_info{5}(damage_pipe_info{3}==2);
isolate_pipe_id = damage_pipe_info{5}(damage_pipe_info{3}==2);
isolation_time_mat = Dp_Inspect_mat(damage_pipe_info{3}==2);
best_indivi_isolation_1_cell = cell(numel(break_pipe_id),1);
the_chose_isolation_inp = cell(numel(break_pipe_id),1);
% for i = numel(break_pipe_id)
% isolation_pipe_record = struct('Current_SSI',[],['isolate_',break_pipe_id{i}],[]);
% end
tic
for i = 1:numel(isolate_pipe_id)
    timecost = toc;
    disp(['=======隔离第',num2str(i),'/',num2str(numel(break_pipe_id) ),'步；时间',num2str(timecost),'S=========='])
    mid_class = greedy_pipe_isolation_priority(temp_inp_file,net_data,break_pipe_id,pipe_relative);
    mid_class.input_check;
    mid_class.out_dir = '.\results\';
    mid_class.Run
    system_s = mid_class.output_system_serviceability;
    isolation_pipe_record(i).current_SSI = mid_class.current_system_serviceability;
%     for i_i = 1:numel(break_pipe_id)
%         isolation_pipe_record(i).(['isolate_pipe_',break_pipe_id{i_i}]) = mid_class.output_system_serviceability(i_i);
%         if system_s(i_i)<mid_class.current_system_serviceability %无论如何不会小于当前的系统满意率，所以如果小于，则等于。
%             system_s(i_i) = mid_class.current_system_serviceability;
%         end
%     end
    
    dynamic_importance = (system_s-mid_class.current_system_serviceability)./isolation_time_mat;
    [max_dy_im_s,max_dy_im_s_loc] = max(dynamic_importance);
    best_indivi_isolation_1_cell{i} = break_pipe_id{max_dy_im_s_loc};
    the_chose_isolation_inp{i} = mid_class.output_inp_file{max_dy_im_s_loc};
    break_pipe_id(max_dy_im_s_loc) = [];
    temp_inp_file = mid_class.output_inp_file{max_dy_im_s_loc};
    isolation_time_mat(max_dy_im_s_loc) = [];
    mid_class.delete
end

recovery_pipe_id = damage_pipe_info{5};
recovery_time_mat = Dp_Repair_mat;
best_indivi_recovery_1_cell = cell(numel(recovery_pipe_id),1);
the_chose_recovery_inp = cell(numel(recovery_pipe_id),1);

for j = 1:numel(recovery_pipe_id)
    timecost = toc;
    disp(['=======修复第',num2str(j),'/',num2str(numel(recovery_pipe_id)),'步；时间',num2str(timecost),'S=========='])
    mid_recovery_class = greedy_pipe_recovery_priority(temp_inp_file,net_data,recovery_pipe_id,pipe_relative);
    mid_recovery_class.input_check;
    mid_recovery_class.out_dir = '.\results\';
    mid_recovery_class.Run
    system_s = mid_recovery_class.output_system_serviceability;
    replacement_pipe_record(j).current_SSI = mid_recovery_class.current_system_serviceability;
%     for j_n = 1:numel(recovery_pipe_id)
%         replacement_pipe_record(j).(['replacement_pipe_',recovery_pipe_id{j_n}]) = mid_recovery_class.output_system_serviceability(j_n);
%         if system_s(j_n)<mid_recovery_class.current_system_serviceability %无论如何不会小于当前的系统满意率，所以如果小于，则等于。
%             system_s(j_n) = mid_recovery_class.current_system_serviceability;
%         end
%     end

    dynamic_recovery_importance = (system_s-mid_recovery_class.current_system_serviceability)./recovery_time_mat;
    [max_dy_im_s,max_dy_im_s_loc] = max(dynamic_recovery_importance);
    best_indivi_recovery_1_cell{j} = recovery_pipe_id{max_dy_im_s_loc};
    the_chose_recovery_inp{j} = mid_recovery_class.output_inp_file{max_dy_im_s_loc};
    recovery_pipe_id(max_dy_im_s_loc) = [];
    temp_inp_file = mid_recovery_class.output_inp_file{max_dy_im_s_loc};
    recovery_time_mat(max_dy_im_s_loc) = [];
    mid_recovery_class.delete
end
% replacement_table = struct2table(replacement_pipe_record);
% isolation_table = struct2table(isolation_pipe_record);
% writetable(replacement_table,'replace.xls');
% writetable(isolation_table,'isolate.xls');
[~,best_indivi_isolation_1_transpose] = ismember(best_indivi_isolation_1_cell,net_data{5,2}(:,1));
[~,best_indivi_recovery_1_transpose] = ismember(best_indivi_recovery_1_cell,net_data{5,2}(:,1));
best_indivi_isolation_1 = best_indivi_isolation_1_transpose';
best_indivi_isolation_1_id = net_data{5,2}(best_indivi_isolation_1,1);
best_indivi_recovery_1 = best_indivi_recovery_1_transpose';
best_indivi_recovery_1_id = net_data{5,2}(best_indivi_recovery_1,1);
end

