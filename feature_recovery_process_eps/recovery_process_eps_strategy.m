% name:recovery_process_eps.m
% net: MOD_5.inp
% 经验教训：所有涉及调用动态链接库的函数和命令必须返回错误代码，并验证是否错误。
% 修复策略为：先隔离断开管道，泄露管道没有隔离过程。
% pro-process
% process
% process_1
% process_2
% post-process

% pre-process
clear;clc;close all;tic;
lib_name = 'EPANETx64PDD';
h_name = 'toolkit.h';
net_file = '..\materials\MOD_30leak.inp';
% net_file = '..\materials\MOD_30leak_Q0.inp';
damage_file = '..\materials\damage01.txt';
% damage_file = '..\materials\damage02.txt';
% damage_net = '.\results\temp_damage_net.inp';
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
    %     path('..\lib\random_singleTime',path);%
    load  EPA_F
end
% process_2 the defintion of parameters
% process_3 read data from file

fid3_3 = fopen(pdd_file,'r');
pdd_data_1 = textscan(fid3_3,'%s%f%f','delimiter','|','headerlines',1);
fclose(fid3_3);
temp3_3 = strtrim(pdd_data_1{1});
pdd_data{1,1} = temp3_3;
pdd_data{1,2} = pdd_data_1{2};
pdd_data{1,3} = pdd_data_1{3};


% process_4 generate damage_net

% process_5 generate recovery event and  priority

% [BreakPipe_result,RepairCrew_result]=priorityList2schedule6(BreakPipePriority,RepairCrew,BreakPipe_order,...
%     Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,output_result_dir);%根据修复次序生成时间表，隔离与修复合并的策略 from 'random\'


% process_6 eps simulation
damage_net= net_file;
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
%
durationSet = (24)*3600;%(s)
% durationSet = 24*7*3600;%(s)
calllib(lib_name,'ENsettimeparam',0,durationSet);
calllib(lib_name,'ENsetoption',0,100);
% calllib(lib_name,'ENsetoption',2,0.1);
errcode2 = calllib(lib_name,'ENopenH');
errcode3 = calllib(lib_name,'ENinitH',0);
temp_t = 0;
temp_tstep = 1;
time_step_n =0;
% PipeStatus = [pipeStatus];
% [newPipeStatus,temeStepChosen] = pipeStatusChange(PipeStatus);

errcode4 = 0;
while (temp_tstep && ~errcode4)
    
     [errcode4,temp_t] = calllib(lib_name,'ENrunH',temp_t);
     [real_pre_chosen_node,cal_demand_chosen_node,req_demand_chosen_node]=Get_chosen_node_value_EPANETx64PDD(lib_name,node_id);
 
    [code,temp_tstep]=calllib(lib_name,'ENnextH',temp_tstep);
end
index = libpointer('int32Ptr',0);
% [errcode6_5,warning] = calllib(lib_name,'ENgetwarning',index);
% post-process
errcode7_1 = calllib(lib_name,'ENcloseH');
errcode7_2 = calllib(lib_name,'ENsaveH');%
errcode7_3 = calllib(lib_name,'ENsetstatusreport',2);
errcode7_4 = calllib(lib_name,'ENsetreport','NODES ALL'); %
errcode7_5 = calllib(lib_name,'ENreport');
errcode7_6 = calllib(lib_name,'ENclose');

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
