% 处理数据绘图
% data_process
% 需要Plot类支持， Written by: K M Masum Habib (http://masumhabib.com)
clear;close all;
% 加载数据
% root = 'C:\Users\hc042\Documents\GitHub\a-comparison-of-2-technologies-that-analyze-resilience\feature_recoveryImportance\';
root = '.\';
n = 9;
data_file = ['test_straighLineDistance_01damage_scenario_case_0',num2str(n)];
load([root,data_file]);
% 绘制每一个个时间点的动态链接库返回值
errcode = priority_straighLineDistance.calculate_code;
Time = 1:numel(errcode);
fig = Plot(Time,errcode);
fig.XLabel = 'Time (h)';
fig.YLabel = 'error code';
fig.Title = ['damage scenario',num2str(n),' errcode in process'];
fig.export(['test_straightLineDistance_damage_scenario_case_0',num2str(n),'errcode','.png']);
fig.delete

% 供水满意率曲线
serviceability = priority_straighLineDistance.serviceability;
fig = Plot(Time,serviceability);
fig.XLabel = 'Time (h)';
fig.YLabel = 'Serviceability';
fig.Title = ['damage scenario',num2str(n),' serviceability v.s. Time'];
fig.export(['test_straightLineDistance_damage_scenario_case_0',num2str(n),'serviceability','.png']);
fig.delete