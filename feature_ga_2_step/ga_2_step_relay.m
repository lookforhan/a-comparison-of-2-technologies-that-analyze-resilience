% name : ga_2_step.m
% pre-process 接力优化50代
clear all;clc;close all;tic;
lib_name = 'EPANETx64PDD';
h_name = 'toolkit.h';
net_file = '..\materials\MOD\MOD_5_mean.inp';
damage_info_file = '..\materials\MOD\damage_scenario_case_05.txt';
load('damage_scenario_case_05relay50_50_50.mat')
isolation_pop = ga_results.isolation_pop_record(end-299:end,:);
replacement_pop = ga_results.replacement_pop_record(end-299:end,:);

jkkjjk
clear ga_results
damage_net = '.\results\temp_damage_net.inp';
damage_rpt = '.\results\temp_damage_net.rpt';
pdd_file = '..\materials\MOD\PDD_parameter.txt';
temp_damage_pdd_inp_file = '.\results\temp_internal_net.inp';
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
    path('..\lib\toolkit',path);
    %     path('..\lib\random_singleTime',path);%
    load  EPA_F
end
% process_2 the defintion of parameters
popsize = 300;%30
generation_Nmax = 60;%30
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
crewStartTime = [0.25;0.25;10^20];
crewEfficiencyRecovery = [1;1;1];
crewEfficiencyIsolation = [1;1;1];
crewEfficiencyTravel = [1;1;1];

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
errcode6_4 = calllib(lib_name,'ENsaveinpfile',temp_damage_pdd_inp_file);
errcode6_5 = calllib(lib_name,'ENclose');
% process_7 genetic algorithm
% [ga_results]...
%     =ga_priority13_epanetx64pdd(popsize,generation_Nmax,probability_crossover,probability_mutation,...种群大小，进化代数，交叉概率，变异概率
%     out_dir,....输出目录
%     RepairCrew,...修复队伍，
%     damage_pipe_info,net_data,pipe_relative,...破坏信息，管网信息，破坏管道相关新建管道
%     EPA_format,...node_original_data,system_original_L,...EPA格式，节点原本数据，系统原本管道长度
%     Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...检查时间，修复时间，移动时间
%     crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel,...
%    temp_inp_file);%
ga = ga_priority();
ga.Out_dir = out_dir;
ga.Net_inp = temp_damage_pdd_inp_file;
ga.Damage_pipe_info = damage_pipe_info;
ga.Net_data = net_data;
ga.Pipe_relative = pipe_relative;
ga.Epa_format = EPA_format;
ga.Isolation_time_mat = Dp_Inspect_mat;
ga.Replacement_time_mat = Dp_Repair_mat;
ga.Displacement_time_mat = Dp_Travel_mat;
%--
ga.Crews = RepairCrew;
ga.Crews_Start_Time = crewStartTime;
ga.Crews_Replacement_Efficiency = crewEfficiencyRecovery;
ga.Crews_Isolation_Efficiency = crewEfficiencyIsolation;
ga.Crews_Displacement_Efficiency = crewEfficiencyTravel;
%--
ga.Popsize_process_isolation = popsize;
ga.Pop_isolation_init = isolation_pop;
ga.Generation_Nmax_process_isolation = generation_Nmax;
ga.Probability_crossover_isolation = probability_crossover;
ga.Probability_mutation_isolation = probability_mutation;
ga.run_process_isolation

ga.Popsize_process_replacement = popsize;
ga.Pop_replacement_init = replacement_pop;
ga.Generation_Nmax_process_replacement = generation_Nmax;
ga.Probability_crossover_replacement = probability_crossover;
ga.Probability_mutation_replacement = probability_mutation;
ga.run_process_replacement
toc
ga_results = ga.Results;
ga_results.costTime = toc;
ga_results.description = ['描述：管网文件为',net_file,'；破坏文件为：',damage_info_file,'；算法为：遗传算法，选择策略：',selection_strategy...
    ,'；遗传算法参数，种群规模:',num2str(popsize),'；进化代数：',num2str(generation_Nmax),'；交叉概率：',num2str(probability_crossover),'；变异概率：',num2str(probability_mutation)...
    'relay on 2'];
[~,file_name,~] = fileparts(damage_info_file);
m = ga_results.system_serviceability;
max(ga_results.recovery_fit_record)
% reshape(m,[numel(m),1]);
% ga_results.system_serviceability_record = m;
save([file_name,'relay50'],'ga_results');
% [max_V,max_Loc] = max(ga_results.replacement_fit_record);
% max_system_serviceability = ga_results.system_serviceability{max_Loc};
% exit
% delete .\results\*.*
% post_process.m
% 在遗传算法后，对最优解进行计算获得合适的解。
% clear;clc;clear all;tic;
% net_file = '..\materials\MOD\MOD_5_mean.inp';
% damage_info_file = 'damage_scenario_case_03.txt';
% out_dir = '.\results\';
% inputArg2 = [file_name,'.txt'];
% load('damage_scenario_case_03.mat')
% inputArg4 = ga_results;
% [outputArg1] = resilienceAnalysis(net_file,inputArg2,out_dir,inputArg4);