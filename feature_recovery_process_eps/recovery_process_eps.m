% name:recovery_process_eps.m
% net: MOD_5.inp
% 经验教训：所有涉及调用动态链接库的函数和命令必须返回错误代码，并验证是否错误。
% pro-process
% process
% process_1
% process_2
% post-process

% pre-process
clear;clc;close all;tic;
lib_name = 'EPANETx64PDD';
h_name = 'toolkit.h';
net_file = '..\materials\MOD_5_lowest.inp';
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
    %     path('..\lib\random_singleTime',path);%
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
% [BreakPipe_result,RepairCrew_result]=priorityList2schedule6(BreakPipePriority,RepairCrew,BreakPipe_order,...
%     Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,output_result_dir);%根据修复次序生成时间表，隔离与修复合并的策略 from 'random\'
[BreakPipe_result,RepairCrew_result]=priorityList2schedule7(BreakPipePriority,BreakPipePriority,RepairCrew,BreakPipe_order,...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,output_result_dir);%根据修复次序生成时间表，隔离与修复分开的策略 from 'random\'
[PipeStatus2,PipeStatusChange]=schedule2pipestatus3(BreakPipe_result);%根据时间表生成管道状态矩阵 from 'random\'
PipeStatus = PipeStatus2;
duration_one = numel(PipeStatus(1,:));

% process_6 eps simulation
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
durationSet = (duration_one-1)*3600;%(s)
% durationSet = 24*7*3600;%(s)
calllib(lib_name,'ENsettimeparam',0,durationSet);
calllib(lib_name,'ENsetoption',0,500);
errcode2 = calllib(lib_name,'ENopenH');
errcode3 = calllib(lib_name,'ENinitH',0);
temp_t = 0;
temp_tstep = 1;
time_step_n =0;
% PipeStatus = [pipeStatus];
% [newPipeStatus,temeStepChosen] = pipeStatusChange(PipeStatus);
[newPipeStatus ,timeStepChose]= pipeStatusChange(PipeStatus);
[newPipeStatusChange ,timeStepChangeChose]= pipeStatusChange(PipeStatusChange);
errcode4 = 0;
while (temp_tstep && ~errcode4)
    time_step_n = time_step_n+1;
    
    if errcode4
        keyboard
    end
    disp(num2str(temp_t))
    disp(num2str(time_step_n))
    [lia,loc] = ismember(time_step_n,timeStepChose);%
    if lia
        fprintf(fid,'%s\r\n','开始修改管道状态');
        str1 = '';
        str2 = '';
        str3 = '';
        mid_status = newPipeStatusChange(:,loc);
        for i = 1:numel(mid_status)
            pipe_status = mid_status(i);
            switch  pipe_status
                case 0
                    continue %
                case 1
                    % isolation
                    str2 = [str2,'隔离管道',pipe_relative{i,1},';'];
                    for j =1:numel(pipe_relative{i,2})% 隔离的管道为当前管道相关联的破坏管道。
                        id = libpointer('cstring',pipe_relative{i,2}{1,j});
                        fprintf(fid,'隔离管道:%s\r\n',pipe_relative{i,2}{1,j} );
                        index =libpointer('int32Ptr',0);
                        [code,id,index]=calllib(lib_name,'ENgetlinkindex',id,index);
                        if code
                            disp(nem2str(code));
                            keyboard
                        end
                        code=calllib(lib_name,'ENsetlinkvalue',index,11,0);%管道id状态为关闭
                        if code
                            disp(nem2str(code));
                            fprintf(fid,'隔离管道:%s出错,代码%s\r\n',id,num2str(code) );
                            keyboard
                        end
                    end
                case 2
                    %reopen
                    str3 = [str3,'修复管道',pipe_relative{i,1},';'];
                    id=libpointer('cstring',pipe_relative{i,1});
                    index =libpointer('int32Ptr',0);
                    [code,id,index]=calllib(lib_name,'ENgetlinkindex',id,index);
                    
                    if code
                        disp(nem2str(code));
                        keyboard
                    end
                    code= calllib(lib_name,'ENsetlinkvalue',index,11,1);
                    fprintf(fid,'reopen管道%s,\r\n',pipe_relative{i,1});
                    if code
                        disp(nem2str(code));
                        fprintf(fid,'reopen管道:%s出错,代码%s\r\n',id,num2str(code) );
                        keyboard
                    end
            end
        end
        str = [str1,str2,str3];
        fprintf(fid,'%s时刻,管道状态修改完毕\r\n',num2str(temp_t) );
    else
        str = '无动作';
        fprintf(fid,'%s时刻,管道状态无需修改完毕\r\n',num2str(temp_t) );
    end
     [errcode4,temp_t] = calllib(lib_name,'ENrunH',temp_t);
     [real_pre_chosen_node,cal_demand_chosen_node,req_demand_chosen_node]=Get_chosen_node_value_EPANETx64PDD(lib_name,node_id);
     Pre{time_step_n} = real_pre_chosen_node;
    Demand{time_step_n}=req_demand_chosen_node;
    cal_Demand{time_step_n}=cal_demand_chosen_node;
    system_serviceability_cell{time_step_n}= sum(cal_demand_chosen_node)/sum(req_demand_chosen_node);
    activity_cell{time_step_n} = str;%记录每个时间步的行为
    [code,temp_tstep]=calllib(lib_name,'ENnextH',temp_tstep);
end

system_serviceability_cell{1}
system_serviceability_cell{end}
% post-process
errcode7_1 = calllib(lib_name,'ENcloseH');
errcode7_2 = calllib(lib_name,'ENsaveH');%
errcode7_3 = calllib(lib_name,'ENsetstatusreport',2);
errcode7_4 = calllib(lib_name,'ENsetreport','NODE ALL'); %
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
