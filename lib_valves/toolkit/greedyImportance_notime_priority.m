function [ best_indivi_isolation_1,best_indivi_recovery_1,best_indivi_isolation_1_id,best_indivi_recovery_1_id] = greedyImportance_notime_priority(damage_pipe_info,net_data,Dp_Inspect_mat,Dp_Repair_mat,temp_inp_file,pipe_relative )
%recoveryImportance_notime_priority 此处显示有关此函数的摘要
%   (系统供水满足率)提高最快的次序
break_pipe_id = damage_pipe_info{5}(damage_pipe_info{3}==2);
isolation_time_mat = Dp_Inspect_mat(damage_pipe_info{3}==2);
best_indivi_isolation_1_cell = cell(numel(break_pipe_id),1);
the_chose_isolation_inp = cell(numel(break_pipe_id),1);
tic
for i = 1:numel(break_pipe_id)  
    timecost = toc;
    disp(['=======隔离第',num2str(i),'/',num2str(numel(break_pipe_id) ),'步；时间',num2str(timecost),'S=========='])
    mid_class = greedy_pipe_isolation_priority(temp_inp_file,net_data,break_pipe_id,pipe_relative);
    mid_class.input_check;
    mid_class.out_dir = '.\results\';
    mid_class.Run
    system_s = mid_class.output_system_serviceablity;
    dynamic_importance = (system_s-mid_class.current_system_serviceablity);
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
    system_s = mid_recovery_class.output_system_serviceablity;
    dynamic_recovery_importance = (system_s-mid_recovery_class.current_system_serviceablity);  
    [max_dy_im_s,max_dy_im_s_loc] = max(dynamic_recovery_importance);
    best_indivi_recovery_1_cell{j} = recovery_pipe_id{max_dy_im_s_loc};
    the_chose_recovery_inp{j} = mid_recovery_class.output_inp_file{max_dy_im_s_loc};
    recovery_pipe_id(max_dy_im_s_loc) = [];
    temp_inp_file = mid_recovery_class.output_inp_file{max_dy_im_s_loc};
    recovery_time_mat(max_dy_im_s_loc) = [];
    mid_recovery_class.delete
end

[~,best_indivi_isolation_1_transpose] = ismember(best_indivi_isolation_1_cell,net_data{5,2}(:,1));
[~,best_indivi_recovery_1_transpose] = ismember(best_indivi_recovery_1_cell,net_data{5,2}(:,1));
best_indivi_isolation_1 = best_indivi_isolation_1_transpose';
best_indivi_isolation_1_id = net_data{5,2}(best_indivi_isolation_1,1);
best_indivi_recovery_1 = best_indivi_recovery_1_transpose';
best_indivi_recovery_1_id = net_data{5,2}(best_indivi_recovery_1,1);
end

