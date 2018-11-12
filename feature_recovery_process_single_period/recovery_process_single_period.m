% name:recovery_process_single_period.m
% net: MOD_5.inp
% pro-process
% process
% process_1
% process_2
% post-process

% pre-process
clear;clc;close all;tic;
lib_name = 'EPANETx64PDD';
h_name = 'toolkit.h';
net_file = '..\materials\MOD.inp';
damage_file = '..\materials\damage01.txt';
% damage_file = '..\materials\damage02.txt';
damage_net = '.\results\temp_damage_net.inp';
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
    %     path('..\lib\EPS',path);%
    path('..\lib\getValue',path);%
    path('..\lib\eventTime',path);% ?
    path('..\lib\random',path);%
    path('..\lib\random_singleTime',path);%
    load  EPA_F
end
% process_2 the defintion of parameters
% process_3 read data from file
[t3_1,net_data] = read_net2_EPANETx64PDD(net_file,EPA_format);% from 'readNet\'
if t3_1
    keyboard
else
    
end
[ t3_2,damage_data ] = read_damage_info( damage_file );% from 'damageNet\'
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
% process_5 generate recovery event and  priority
BreakPipe_order=num2cell(damage_pipe_info{1});% 修复优先次序
[ Dp_Inspect_mat,Dp_Repair_mat ,Dp_Travel_mat1] = event_time2( damage_pipe_info,net_data);% from 'eventTime\'
Dp_Travel_mat=Dp_Travel_mat1*0;% 不考虑修复队伍移动时间的影响。
BreakPipePriority = BreakPipe_order;% 修复次序
RepairCrew = {'a'};
output_result_dir = out_dir;

[BreakPipe_result,RepairCrew_result]=priorityList2schedule6(BreakPipePriority,RepairCrew,BreakPipe_order,...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,output_result_dir);%根据修复次序生成时间表 from 'random\'
[PipeStatus2,PipeStatusChange]=schedule2pipestatus3(BreakPipe_result);%根据时间表生成管道状态矩阵 from 'random\'
PipeStatus = PipeStatus2;
duration_one = numel(PipeStatus(1,:));
% pprocess_6 generate original inp file
errcode1 = calllib(lib_name,'ENopen',damage_net,[out_dir,'damage.rpt'],'');% from 'EPANETx64PDD.dll'
if errcode1~=0
    keyboard
end
node_id = pdd_data{1};
Hcritical = pdd_data{2};
Hminimum = pdd_data{3};
index = libpointer('int32Ptr',0);
errcode6_4 = calllib(lib_name,'ENsaveinpfile',temp_inp_file);
errcode6_5 = calllib(lib_name,'ENclose');
% process_7 single-period simulation
timeStep_end=numel(PipeStatus(1,:));%时间步数
for timeStep_i=1:timeStep_end
    PipeStatus_timeStep=PipeStatus(:,timeStep_i);
    [outdata]=timeStepNet(PipeStatus_timeStep,damage_pipe_info,net_data);%输出当前时间步的管道状态管网信息。
    output_net_filename_n =['.\results\','temp_',num2str(timeStep_i),'.inp'];
    output_net_rpt = ['.\results\','temp_',num2str(timeStep_i),'.rpt'];
    output_net_pdd_file_n = ['.\results\','temp_pdd_',num2str(timeStep_i),'.inp'];
    errcode7_1=Write_Inpfile4(net_data,EPA_format,outdata,output_net_filename_n);% 写入新管网inp
    inputdata=output_net_filename_n;
    errcode7_2 = calllib(lib_name,'ENopen',damage_net,output_net_rpt ,'');% from 'EPANETx64PDD.dll'
    for j_i = 1:numel(node_id)
        [errcode7_3,cstring,index]=calllib(lib_name,'ENgetnodeindex',node_id{j_i},index);
        errcode7_4 = calllib(lib_name,'ENsetnodevalue',index,120,Hminimum(j_i));
        errcode7_5 = calllib(lib_name,'ENsetnodevalue',index,121,Hcritical(j_i));
    end
    errcode7_6 = calllib(lib_name,'ENsaveinpfile',output_net_pdd_file_n);
    errcode7_7 = calllib(lib_name,'ENsolveH');
    calllib(lib_name,'ENsaveH');%保存
    calllib(lib_name,'ENsetreport','NODES ALL'); % 设置输出报告的格式
    calllib(lib_name,'ENsetstatusreport',2);
    calllib(lib_name,'ENreport'); %输出计算报告
    [real_pre_chosen_node,cal_demand_chosen_node,req_demand_chosen_node]=Get_chosen_node_value_EPANETx64PDD(lib_name,node_id);
    Pre{timeStep_i} = real_pre_chosen_node;
    Demand{timeStep_i}=req_demand_chosen_node;
    cal_Demand{timeStep_i}=cal_demand_chosen_node;
    system_serviceability_cell{timeStep_i}= sum(cal_demand_chosen_node)/sum(req_demand_chosen_node);
end
% post-process
system_serviceability_cell{1}
system_serviceability_cell{end}
% post-process
calllib(lib_name,'ENcloseH');
calllib(lib_name,'ENsaveH');%
calllib(lib_name,'ENsetstatusreport',2);
calllib(lib_name,'ENsetreport','NODE ALL'); %
calllib(lib_name,'ENreport');
calllib(lib_name,'ENclose');

if false
    
    n_node = numel(Pressure{1});
    node_id = net_data{2,2}(:,1);
    node_data = cell(n_node+3,1);
    for i = 1:numel(Pressure)
        p = [time_step_n_cell(i);TimeStep(i);{'压力'};num2cell(Pressure{i})];
        d = [time_step_n_cell(i);TimeStep(i);{'需水量'};num2cell(Demand{i})];
        r = [time_step_n_cell(i);TimeStep(i);{'原需水量'};num2cell(real_demand_chosen_cell{i})];
        node_data = [node_data,p,d,r];
    end
    node_data (:,1)=[];
    node_data = [[{'时间步'};{'时间'};{'节点id'};node_id],node_data];
    xlswrite([output_result_dir,'EPS_net2-1.xls'],node_data');
end
% fclose(fid);
errcode =0;
