% �������ݻ�ͼ
% data_process
% ��ҪPlot��֧�֣� Written by: K M Masum Habib (http://masumhabib.com)
%
% ��������
root = 'C:\Users\hc042\Documents\GitHub\a-comparison-of-2-technologies-that-analyze-resilience\feature_recoveryImportance\';
n = 5;
data_file = ['test_greedy_damage_scenario_case_0',num2str(n),'_5000'];
load([root,data_file]);
% ����ÿһ����ʱ���Ķ�̬���ӿⷵ��ֵ
errcode = priority_greedyImportance.calculate_code;
Time = 1:numel(errcode);
fig = Plot(Time,errcode);
fig.XLabel = 'Time (h)';
fig.YLabel = 'error code';
fig.Title = ['damage scenario',num2str(n),' errcode in process'];
fig.export(['test_greedy_damage_scenario_case_0',num2str(n),'errcode','.png']);
fig.delete

% ��ˮ����������
serviceability = priority_greedyImportance.serviceability;
fig = Plot(Time,serviceability);
fig.XLabel = 'Time (h)';
fig.YLabel = 'Serviceability';
fig.Title = ['damage scenario',num2str(n),' serviceability v.s. Time'];
fig.export(['test_greedy_damage_scenario_case_0',num2str(n),'serviceability','.png']);
fig.delete