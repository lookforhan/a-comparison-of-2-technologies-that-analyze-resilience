% test_summarize_damage_pipe.m
% 生成管道状态的程序。
clear;clc;close all;tic;
lib_name = 'EPANETx64PDD';
h_name = 'toolkit.h';
net_file = '..\materials\MOD_5_mean.inp';
scenario_n = 1;
damage_info_file_name = ['damage_scenario_case_0',num2str(scenario_n),'.txt'];
damage_info_file = ['..\materials\',damage_info_file_name];
damage_net = '.\results\temp_damage_net.inp';
damage_rpt = '.\results\temp_damage_net.rpt';
pdd_file = '..\materials\PDD_parameter.txt';
temp_inp_file = '.\results\temp_internal_net.inp';
out_dir = '.\results\';
fid = 1;
% process
% process_1 load function lib
loadlibrary(['..\materials\',lib_name],['..\materials\',h_name]);
try
    load  EPA_F
catch
    path('..\lib\readNet',path);%
    path('..\lib\damageNet',path);%
    path('..\lib\EPS',path);%
    path('..\lib\getValue',path);%
    path('..\lib\eventTime',path);% ?
    path('..\lib\random',path);%
    path('..\lib\ga',path);%
    path('..\lib\Class',path);% 类
    %     path('..\lib\random_singleTime',path);%
    load  EPA_F
end
% process_2 the defintion of parameters
popsize = 300;%30
generation_Nmax = 100;%30
probability_crossover = 0.9;
probability_mutation = 0.1;
selection_strategy = 'elitism selection';
% process_3 read data from file
[t3_1,net_data] = read_net2_EPANETx64PDD(net_file,EPA_format);% from 'readNet\'
if t3_1
    keyboard
else
    
end
for i = 1:9
    scenario_n = i;
 damage_info_file_name = ['damage_scenario_case_0',num2str(scenario_n),'.txt'];  
 damage_info_file = ['..\materials\',damage_info_file_name];
[ t3_2,damage_data ] = read_damage_info( damage_info_file );% from 'damageNet\'
if t3_2
    keyboard
end
fid3_3 = fopen(pdd_file,'r');
pdd_data_1 = textscan(fid3_3,'%s%f%f','delimiter','|','headerlines',1);
fclose(fid3_3);
temp3_3 = strtrim(pdd_data_1{1});
pdd_data{1,1} = temp3_3;
pdd_data{1,2} = pdd_data_1{2};
pdd_data{1,3} = pdd_data_1{3};
% process_4 generate damage_net

[t4_2,damage_pipe_info] = ND_Execut_deterministic1(net_data,damage_data);% from 'damageNet\'
if t4_2
    keyboard
end
damage_pipe_info_cell{i} = damage_pipe_info;
end
pipe_id = net_data{5,2}(:,1);
pipe_status = cell(numel(pipe_id),5);
for j = 1:9
damage_Pipe_info = damage_pipe_info_cell{j};
    pipe_status(:,j) = {'正常'};
pipe_status(damage_Pipe_info{1}(damage_Pipe_info{3}==1),j) ={'泄漏'};
pipe_status(damage_Pipe_info{1}(damage_Pipe_info{3}==2),j) ={'断开'};
end
output = [pipe_id,pipe_status];
xlswrite('pipe_status.xls',output);