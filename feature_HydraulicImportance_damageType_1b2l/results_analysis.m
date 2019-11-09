% results.analysis

% s1 = load('test_hydraulic_pdddamage_scenario_case_01.mat');
% s2 = load('test_hydraulic_pdddamage_scenario_case_02.mat');
% s3 = load('test_hydraulic_pdddamage_scenario_case_03.mat');
% s4 = load('test_hydraulic_pdddamage_scenario_case_04.mat');
% s5 = load('test_hydraulic_pdddamage_scenario_case_05.mat');
% s6 = load('test_hydraulic_pdddamage_scenario_case_06.mat');
% s7 = load('test_hydraulic_pdddamage_scenario_case_07.mat');
% s8 = load('test_hydraulic_pdddamage_scenario_case_08.mat');
% s9 = load('test_hydraulic_pdddamage_scenario_case_09.mat');
s = cell(9,1);
for i = 1:9
filename = ['test_hydraulic_pdddamage_scenario_case_0',num2str(i),'.mat'];
s{i} = load (filename);
end
 for i = 1:9
     s{i}.priority_hydraulicImportance.resilience_mean_serviceability
 end