% 对工况3的进一步研究和出来
% damage_scenario_03_process
clear;clc;close all;
root = '.\';
data_file = 'test_straighLineDistance_01damage_scenario_case_03.mat';
load(data_file);
n = 3;
code = priority_straighLineDistance.calculate_code;
length = numel(code);
Time = 1:length;
errcode_loc = find(code~=0);
reliable_code_loc  = find(code ==0); 
err_serviceability = priority_straighLineDistance.serviceability(errcode_loc);
reliable_time = Time(reliable_code_loc);
reliable_serviceability = priority_straighLineDistance.serviceability(reliable_code_loc);
fig = Plot(reliable_time,reliable_serviceability);
fig.XLabel = 'Time (h)';
fig.YLabel = 'Serviceability';
fig.Title = ['damage scenario',num2str(n),' reliable serviceability v.s. Time'];
fig.export(['test_straightLineDistance_damage_scenario_case_0',num2str(n),'reliable_serviceability','.png']);
fig.delete;
activitys = priority_straighLineDistance.activity(1:errcode_loc);