%  the priority record
clear;clc;close all;tic;
net_file = '..\materials\MOD\MOD_5_mean.inp';
damage_scenario = 3;
strategy = 'GAOM';%'GAOM';%'DCBM';%'MCM';%SCM
damage_info_file_name = ['damage_scenario_case_0',num2str(damage_scenario),'.txt'];
pre_process
hydraulic_importance = pipeHydraulicImportant(net_file);
pipe_id = net_data{5,2}(:,1);
% process_7
% priority = struct('serviceability',[],'resilience_mean_serviceability',[],'resilience_mean_recovery_rate',[],'ENrun_num',[]);

% 确定次序
switch sum(abs(strategy))
% SCM
    case 227
[ best_indivi_isolation_1,best_indivi_recovery_1,best_indivi_isolation_1_id,best_indivi_recovery_1_id ] = hydralicImpotance_priority( damage_pipe_info,net_data );
% MCM
    case 221
best_indivi_isolation_1_cell =damage_pipe_info{5}(damage_pipe_info{3}==2);
best_indivi_recovery_1_2_cell = damage_pipe_info{5}(damage_pipe_info{3}==1);
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
    case 278
        load(['test_greedy1104_best_pdddamage_scenario_case_0',num2str(damage_scenario),'.mat']);
         best_indivi_isolation_1_id = priority_greedy_best.isolation_priority';
         [~,best_indivi_isolation_2] = ismember(best_indivi_isolation_1_id,pipe_id);
         best_indivi_isolation_1 = best_indivi_isolation_2';
         best_indivi_recovery_1_id = priority_greedy_best.recovery_priority';
         [~,best_indivi_recovery_2] = ismember(best_indivi_recovery_1_id,pipe_id);
         best_indivi_recovery_1 = best_indivi_recovery_2';
    case 343
        load(['test_greedy_damage_scenario_case_0',num2str(damage_scenario),'_5000.mat'])
        best_indivi_isolation_1_id =  priority_greedyImportance.isolation_priority;
         [~,best_indivi_isolation_2] = ismember(best_indivi_isolation_1_id,pipe_id);
         best_indivi_isolation_1 = best_indivi_isolation_2';
         best_indivi_recovery_1_id =  priority_greedyImportance.recovery_priority;
         [~,best_indivi_recovery_2] = ismember(best_indivi_recovery_1_id,pipe_id);
         best_indivi_recovery_1 = best_indivi_recovery_2';
    case 292
        load(['test_ga_best_pdddamage_scenario_case_0',num2str(damage_scenario),'.mat'])
        
        best_indivi_isolation_1_id = priority_ga_best.isolation_priority';
        [~,best_indivi_isolation_2] = ismember(best_indivi_isolation_1_id,pipe_id);
        best_indivi_isolation_1 = best_indivi_isolation_2';
        best_indivi_recovery_1_id = priority_ga_best.recovery_priority';
        [~,best_indivi_recovery_2] = ismember(best_indivi_recovery_1_id,pipe_id);
        best_indivi_recovery_1 = best_indivi_recovery_2';

end

DamagePipe_order = unique(damage_pipe_info{1});
num_isolate = numel(best_indivi_isolation_1);
num_recovery = numel(best_indivi_recovery_1);
priority_pipe = struct('isolate_loc',[],'isolate_id',[],'recovery_loc',[],'recovery_id',[]);
priority_pipe.isolate_loc =[ num2cell(best_indivi_isolation_1)';cell(num_recovery-num_isolate,1)];
priority_pipe.isolate_id = [best_indivi_isolation_1_id;cell(num_recovery-num_isolate,1)];
priority_pipe.recovery_loc = num2cell(best_indivi_recovery_1)';
priority_pipe.recovery_id = best_indivi_recovery_1_id;
result_table = struct2table(priority_pipe);
filename = [strategy,'case',num2str(damage_scenario),'.mat'];
save(filename,'priority_pipe');
writetable(result_table,[strategy,'.xlsx'],'sheet',damage_scenario);
priority_all = cell(num_recovery+num_isolate,1);
priority_all_id = [best_indivi_isolation_1_id;best_indivi_recovery_1_id];
for i = 1:num_recovery+num_isolate
    if i<num_isolate+1
        priority_all{i} = ['Isolate pipe',priority_all_id{i}];
    else
        if ismember(priority_all_id{i},best_indivi_isolation_1_id)
            priority_all{i} = ['Replace pipe',priority_all_id{i}];
        else
            priority_all{i} = ['Repair pipe',priority_all_id{i}];
        end
    end
end
writecell(priority_all,[strategy,'2.xlsx'],'sheet',damage_scenario)