% name:recovery_process_eps.m
% net: MOD_3.inp
% pro-process
% process
% process_1
% process_2
% post-process

% pre-process
clear;clc;close all;tic;
lib_name = 'EPANETx64PDD';
h_name = 'toolkit.h';
net_file = '..\materials\MOD_3.inp';
damage_file = 'damage_1.txt';
damage_net = '.\results\damage_net.inp'
out_dir = '.\results\';
fid = 1;
% process
% process_1 load function lib
loadlibrary(['..\materials\',lib_name],['..\materials\',h_name]);
try
    load  EPA_F
catch
    path('..\lib\toolkit',path);
    path('..\lib\readNet',path);% 读取inp文件
    path('..\lib\damageNet',path);% 管道破坏
    path('..\lib\EPS',path);% 延时模拟
    path('..\lib\getValue',path);% 获得参数值
    path('..\lib\eventTime',path);% 事件发生时间发生器
    path('..\lib\random',path);% 
    path('..\lib\random_singleTime',path);% 单点模拟所需的函数。
    load  EPA_F2
end
% process_2 the defintion of parameters
% process_3 read data from file
[t1,net_data] = read_net(net_file,EPA_format);% from 'readNet\'
if t1
    keyboard
    else

end
[t2,damage_pipe_info] = ND_Execut_deterministic(net_data,damage_file);% from 'damageNet\'
if t2
    keyboard
    else

end

% process_4 generate damage_net
[t3,pipe_relative] = damageNetInp2_GIRAFFE2(net_data,damage_pipe_info,EPA_format,damage_net);% from 'damageNet\'
if t3
    keyboard
    else

end
% process_5 eps simulation
errcode1 = calllib(lib_name,'ENopen',damage_net,[out_dir,'damage.rpt'],'');% from 'EPANETx64PDD.dll'
errcode2 = calllib(lib_name,'ENopenH');
errcode3 = calllib(lib_name,'ENinitH',0);
temp_t = 0;
temp_tstep = 1;
time_step_n =0;
PipeStatus = [pipeStatus];
[newPipeStatus,temeStepChosen] = (PipeStatus);
while (temp_tstep && ~errcode4)
    time_step_n = time_step_n+1;
    [errcode4,temp_t] = calllib(lib_name,'ENrunH',temp_t);
    if errcode4
        keyboard
    end
    disp(num2str(temp_t))
    disp(num2str(time_step_n))
    [lia,loc] = ismember(time_step_n,timeStepChosen);% 比较是否到修改的时间步
    if lia
        fprintf(fid,'%s\r\n','开始修改管道状态');
        
        mid_status = newPipeStatus(:,loc);
        for i = 1:numel(mid_status)
            pipe_status = mid_status(i);
            switch  pipe_status
                case 2
                    continue %该管道没有修复
                case 1
                    %管道隔离
                    for j =1:numel(pipe_relative{i,2})% 隔离的管道为当前管道相关联的破坏管道。
                        id = libpointer('cstring',pipe_relative{i,2}{1,j});
                        fprintf(fid,'隔离管道:%s\r\n',pipe_relative{i,2}{1,j} );
                        index =libpointer('int32Ptr',0);
                        [code,id,index]=calllib('epanet2','ENgetlinkindex',id,index);
                        if code
                            disp(nem2str(code));
                            keyboard
                        end
                        code=calllib('epanet2','ENsetlinkvalue',index,11,0);%管道id状态为关闭
                        if code
                            disp(nem2str(code));
                            fprintf(fid,'隔离管道:%s出错,代码%s\r\n',id,num2str(code) );
                            keyboard
                        end
                    end
                case 0
                    %reopen 管道，说明该管道修复
                    id=libpointer('cstring',pipe_relative{i,1});
                    index =libpointer('int32Ptr',0);
                    [code,id,index]=calllib('epanet2','ENgetlinkindex',id,index);
                   
                    if code
                        disp(nem2str(code));
                        keyboard
                    end
                    code= calllib('epanet2','ENsetlinkvalue',index,11,1);
                     fprintf(fid,'reopen管道%s,\r\n',pipe_relative{i,1});
                    if code
                        disp(nem2str(code));
                        fprintf(fid,'reopen管道:%s出错,代码%s\r\n',id,num2str(code) );
                        keyboard
                    end
            end
        end
        fprintf(fid,'%s时刻,管道状态修改完毕\r\n',num2str(temp_t) );
    else
        fprintf(fid,'%s时刻,无需修改管道状态\r\n',num2str(temp_t) );
    end
    
    [code,temp_tstep]=calllib('epanet2','ENnextH',temp_tstep);

    end
end

% post-process
calllib(lib_name,'ENcloseH');
calllib(lib_name,'ENsaveH');%保存水力文件
calllib(func_name,'ENsetstatusreport',2);
calllib(lib_name,'ENsetreport','NODES ALL'); % 设置输出报告的格式
calllib(lib_name,'ENreport');
calllib(lib_name,'ENclose');
