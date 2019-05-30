% 生成随机破坏矩阵
clear;clc;close all;tic;
lib_name = 'EPANETx64PDD';
h_name = 'toolkit.h';
net_file = '..\..\materials\MOD\MOD_5_mean.inp';
out_dir = '.\results\';
loadlibrary(['..\..\materials\',lib_name],['..\..\materials\',h_name]);
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
% process_3 read data from file
[t3_1,net_data] = read_net2_EPANETx64PDD(net_file,EPA_format);% from 'readNet\'
if t3_1
    keyboard
else
end
damage_pipe_num = 300;
break_pipe_num =1;
out_file = '..\materials\damage_scenario_case_03_1.txt';
t = Create_damage_info(net_data);
t.break_pipe_id ={ '1'};
t.leak_pipe_id = {'3';'5'};

% t = Create_damage_info(damage_pipe_num,break_pipe_num,out_file,net_data);
% t.Run
% % 生成破坏信息
% 
% damage_equ_diameter = zeros(damage_pipe_num,1);
% pipe_id = net_data{5,2}(:,1);
% pipe_diameter = net_data{5,2}(:,5);
% randnum = randperm(numel(pipe_id));
% damage_pipe_id = pipe_id(randnum(1:damage_pipe_num));% 破坏管道id
% damage_pipe_diameter = pipe_diameter(randnum(1:damage_pipe_num));
% 
% damage_pipe_class_1 = ones(numel(damage_pipe_id),1);
% randnum_2 = randperm(numel(damage_pipe_id));
% 
% break_pipe_id = damage_pipe_id(randnum_2(1:break_pipe_num));
% damage_pipe_class_1(randnum_2(1:break_pipe_num)) =2;
% [damage_pipe_id,damage_pipe_diameter,num2cell(damage_pipe_class_1)]
% damage_equ_diameter(damage_pipe_class_1==2) = cell2mat(damage_pipe_diameter(damage_pipe_class_1==2));
% damage_equ_diameter(damage_pipe_class_1==1) = cell2mat(damage_pipe_diameter(damage_pipe_class_1==1))*0.25;
% [damage_pipe_id,damage_pipe_diameter,num2cell(damage_equ_diameter),num2cell(damage_pipe_class_1)]
% 
% %
% damage_node_num = ones(damage_pipe_num,1);
% damage_node_distance = ones(damage_pipe_num,1)*0.5;
% damage_node_priority = (1:damage_pipe_num)';
% damage_data = {damage_node_priority,damage_pipe_id,damage_node_num,damage_node_distance,damage_pipe_class_1,damage_equ_diameter};
% %
% [t4_2,damage_pipe_info] = ND_Execut_deterministic1(net_data,damage_data);
% 
% [ errcode ] = write_Damagefile( damage_pipe_info, out_file );%生成破坏文件

