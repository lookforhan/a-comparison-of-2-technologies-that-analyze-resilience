% name : ga_2_step.m
% pre-process
clear all;clc;close all;tic;
lib_name = 'EPANETx64PDD';
h_name = 'toolkit.h';
net_file = '..\materials\MOD\MOD_5_mean.inp';
damage_info_file = '..\materials\MOD\damage_scenario_05.txt';
damage_net = '.\results\temp_damage_net.inp';
damage_rpt = '.\results\temp_damage_net.rpt';
pdd_file = '..\materials\MOD\PDD_parameter2.txt';
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
    path('..\lib\Class',path);%
    %     path('..\lib\random_singleTime',path);%
    load  EPA_F
end
% process_2 the defintion of parameters
popsize = 10;%30
generation_Nmax = 5;%30
probability_crossover = 0.9;
probability_mutation = 0.1;
selection_strategy = 'elitism selection';
% process_3 read data from file
[t3_1,net_data] = read_net2_EPANETx64PDD(net_file,EPA_format);% from 'readNet\'
if t3_1
    keyboard
else
    
end
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
[t3,pipe_relative] = damageNetInp2_GIRAFFE2(net_data,damage_pipe_info,EPA_format,damage_net);% from 'damageNet\'
if t3
    keyboard
else
end
% process_5 generate recovery event 
[ Dp_Inspect_mat,Dp_Repair_mat ,Dp_Travel_mat1] = event_time2( damage_pipe_info,net_data);% from 'eventTime\'
Dp_Travel_mat=Dp_Travel_mat1*0;% 不考虑修复队伍移动时间的影响。
RepairCrew = {'a';'b';'c'};
crewStartTime = [0.15;0.25;10^20];
crewEfficiencyRecovery = [1;1;1];
crewEfficiencyIsolation = [0.9;1;1.5];
crewEfficiencyTravel = [1.5;1;0.6];

% process_6 damage inp file with pdd parameter

errcode6_1 = calllib(lib_name,'ENopen',damage_net,[out_dir,'damage.rpt'],'');% from 'EPANETx64PDD.dll'
if errcode6_1~=0
    keyboard
end
node_id = pdd_data{1};
Hcritical = pdd_data{2};
Hminimum = pdd_data{3};
value=libpointer('doublePtr',0);%指针参数--值
index = libpointer('int32Ptr',0);
for j_i = 1:numel(node_id)
    [errcode6_1,cstring,index]=calllib(lib_name,'ENgetnodeindex',node_id{j_i},index);
    errcode6_2 = calllib(lib_name,'ENsetnodevalue',index,120,Hminimum(j_i));
    errcode6_3 = calllib(lib_name,'ENsetnodevalue',index,121,Hcritical(j_i));
end
errcode6_4 = calllib(lib_name,'ENsaveinpfile',temp_inp_file);
errcode6_5 = calllib(lib_name,'ENclose');
% process_7 genetic algorithm
[ga_results]...
    =ga_priority13_epanetx64pdd(popsize,generation_Nmax,probability_crossover,probability_mutation,...种群大小，进化代数，交叉概率，变异概率
    out_dir,....输出目录
    RepairCrew,...修复队伍，
    damage_pipe_info,net_data,pipe_relative,...破坏信息，管网信息，破坏管道相关新建管道
    EPA_format,...node_original_data,system_original_L,...EPA格式，节点原本数据，系统原本管道长度
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...检查时间，修复时间，移动时间
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel,...
   temp_inp_file);%
toc