% �������ݻ�ͼ
% data_process
% ��ҪPlot��֧�֣� Written by: K M Masum Habib (http://masumhabib.com)
clear;close all;
% ��������
% root = 'C:\Users\hc042\Documents\GitHub\a-comparison-of-2-technologies-that-analyze-resilience\feature_recoveryImportance\';
root = '.\';
n = 9;
data_file = ['test_straighLineDistance_01damage_scenario_case_0',num2str(n)];
load([root,data_file]);
% ����ÿһ����ʱ���Ķ�̬���ӿⷵ��ֵ
errcode = priority_straighLineDistance.calculate_code;
Time = 1:numel(errcode);
fig = Plot(Time,errcode);
fig.XLabel = 'Time (h)';
fig.YLabel = 'error code';
fig.Title = ['damage scenario',num2str(n),' errcode in process'];
fig.export(['test_straightLineDistance_damage_scenario_case_0',num2str(n),'errcode','.png']);
fig.delete

% ��ˮ����������
serviceability = priority_straighLineDistance.serviceability;
fig = Plot(Time,serviceability);
fig.XLabel = 'Time (h)';
fig.YLabel = 'Serviceability';
fig.Title = ['damage scenario',num2str(n),' serviceability v.s. Time'];
fig.export(['test_straightLineDistance_damage_scenario_case_0',num2str(n),'serviceability','.png']);
fig.delete