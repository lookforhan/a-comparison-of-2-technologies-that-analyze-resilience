function [outputArg1] = resilienceAnalysis(inputArg1,inputArg2,inputArg3,inputArg4,inputArg5)
%resilienceAnalysis 计算管网破坏后韧性
%   此处显示详细说明
net_file = inputArg1;
damage_info_file_name = inputArg2;
out_dir = inputArg3;
best_indivi_isolation = inputArg4;
best_indivi_recovery = inputArg5;
% pre_process begin
lib_name = 'EPANETx64PDD';
% h_name = 'toolkit.h';
damage_info_file = ['E:\hanzhao\a-comparison-of-2-technologies-that-analyze-resilience\materials\MOD\',damage_info_file_name];
damage_net = '.\results\temp_damage_net.inp';
damage_rpt = '.\results\temp_damage_net.rpt';
pdd_file = 'E:\hanzhao\a-comparison-of-2-technologies-that-analyze-resilience\materials\MOD\PDD_parameter.txt';
temp_inp_file = '.\results\temp_internal_net.inp';
% fid = 1;
% loadlibrary(['..\materials\',lib_name],['..\materials\',h_name]);
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
    path('..\lib\toolkit',path);%\
    path('E:\hanzhao\PlotPub\lib',path);
    %     path('..\lib\random_singleTime',path);%
    load  EPA_F
end
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
    [~,~,index]=calllib(lib_name,'ENgetnodeindex',node_id{j_i},index);
    errcode6_2 = calllib(lib_name,'ENsetnodevalue',index,120,Hminimum(j_i));
    errcode6_3 = calllib(lib_name,'ENsetnodevalue',index,121,Hcritical(j_i));
end
% node_set_zeros = {'221';'12'};
% node_set_value = zeros(numel(node_set_zeros),1);
% [err5] = Set_chosen_node_value_EPANETx64PDD(lib_name,node_set_zeros,1,node_set_value);
errcode6_4 = calllib(lib_name,'ENsaveinpfile',temp_inp_file);
errcode6_5 = calllib(lib_name,'ENclose');
% pre_process end
global n_ENrun
n_ENrun = 0 ;
% n1 = n_ENrun;
% 计算可能的时间
disp(damage_info_file_name);
priority = struct('serviceability',[],'resilience_mean_serviceability',[],'resilience_mean_recovery_rate',[]);
% 确定次序
best_indivi_isolation_1 = best_indivi_isolation;
best_indivi_recovery_1 = best_indivi_recovery;
DamagePipe_order = unique(damage_pipe_info{1});
% 开始计算
[~,...
    ~,...
    ~,...
    system_serviceability_cell,...
    activity_cell,results,schedule]...
    =fit8_recovery...
    (best_indivi_isolation_1,best_indivi_recovery_1,...
    DamagePipe_order,RepairCrew,...
    Dp_Inspect_mat,...
    Dp_Repair_mat,Dp_Travel_mat,...
    net_data,...
    out_dir,...
    temp_inp_file,...
    pipe_relative,...
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel,0);%评价种群个体适应度
% 后处理，出结果
priority_results = priority;
priority_results.activity = activity_cell;
% priority_results.isolation_priority = best_indivi_isolation_1_id;
% priority_results.recovery_priority = best_indivi_recovery_1_id;
priority_results.serviceability = cell2mat(system_serviceability_cell);
mid = cal_resilience_index(priority_results.serviceability);
priority_results.resilience_mean_serviceability = mid.resilience_index_mean_serviceability;
mid.index = 0.9;
priority_results.resilience_mean_recovery_rate = mid.resilience_index_mean_recovery_rate;
mid.delete
priority_results.ENrun_num = n_ENrun;
priority_results.crew_active = schedule.schedule_table_crew_pipeID;
priority_results.active_type = schedule.schedule_table_crew_activeType;
priority_results.calculate_code = results.calculate_code;
delete ([out_dir,'*'])
outputArg1 = priority_results;
end

