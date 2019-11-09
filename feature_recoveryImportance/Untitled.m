clear;clc;tic;
load('data.mat');

% T2 :¹Ø¼ü±äÁ¿%
% for i = 1:numel(T2.ActiveType)
%     event_start(i).time = T2.StartTime(i);
%     event_start(i).id = T2.PipeID(i);
%     event_start(i).type = T2.ActiveType(i);
%     event_end(i).time = T2.EndTime(i);
%     event_end(i).id = T2.PipeID(i);
%     event_end(i).type = T2.ActiveType(i);
% end
Time = [T2.StartTime;T2.EndTime];
uniq_time = unique(Time);
startEvent = cell(numel(uniq_time),1);
endEvent = cell(numel(uniq_time),1);
% loc = ismember(uniq_time,event_start(5).time);
% loc = ismember(uniq_time,T2.StartTime);
for i = 1:numel(T2.ActiveType)
    
    if T2.ActiveType(i) == 1
        str = ['{isolation:',num2str(T2.PipeID(i)),'};'];
    else
        str = ['{replacement:',num2str(T2.PipeID(i)),'};'];
    end
    loc1 = ismember(uniq_time,T2.StartTime(i));
    loc2 = ismember(uniq_time,T2.EndTime(i));
    if isempty(startEvent{loc1})
        startEvent{loc1} = str;
    else
        startEvent{loc1} = [startEvent{loc1},str];
    end
    if isempty(endEvent{loc2})
        endEvent{loc2} = str;
    else
        endEvent{loc2} = [endEvent{loc2},str];
    end
end
results = cell2table([num2cell(uniq_time),startEvent,endEvent],'VariableNames',{'Time','Start','End'});
%========================
net_file = 'E:\hanzhao\a-comparison-of-2-technologies-that-analyze-resilience\\materials\MOD\MOD_5_mean.inp';
damage_info_file = 'damage_scenario_case_09.txt';
out_dir = '.\results\';
inputArg2 = damage_info_file;
% load('damage_scenario_case_09relay50_50.mat')
% load('damage_scenario_case_01.mat')
load('test_greedy_adjustdamage_scenario_case_09_5000_new.mat')
% ga_results.best_indivi_recovery = ga_results.best_indivi_replacement;
inputArg4 = priority_greedyImportance.isolation_priority_loc;
inputArg5 = priority_greedyImportance.recovery_priority_loc;
%====================
lib_name = 'EPANETx64PDD';
h_name = 'toolkit.h';
loadlibrary(['..\materials\',lib_name],['..\materials\',h_name]);
% [outputArg1] = resilienceAnalysis(net_file,inputArg2,out_dir,inputArg4,inputArg5);
outputArg1.serviceability
outputArg1.resilience_mean_serviceability
%
p = plot_solid_serviceability(outputArg1.calculate_code,outputArg1.serviceability);
f1 = figure();
p.plot(f1);
