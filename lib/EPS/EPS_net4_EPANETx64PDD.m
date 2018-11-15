function [ errcode,Pre,Demand,cal_Demand, system_serviceability_cell,activity_cell] = EPS_net4_EPANETx64PDD( output_net_filename_inp,output_result_dir,PipeStatus,PipeStatusChange,pipe_relative,net_data,...
    duration_one)
%ESP_net 管网延时模拟
%   在管网延时模拟中使用PDD模型
%   增加管道状态改变矩阵 2018-8-26
%   基于EPANETx64PDD.dll 2018-11-15
%
%pre-process

funcName = 'EPS_net4_EPANETx64PDD';
lib_name = 'EPANETx64PDD';
Pre = cell(duration_one,1);
Demand = cell(duration_one,1);
cal_Demand = cell(duration_one,1);
system_serviceability_cell = cell(duration_one,1);
activity_cell = cell(duration_one,1);
fid=1;
node_id = net_data{2,2}(:,1);
% process
errcode(1) = calllib(lib_name,'ENopen',output_net_filename_inp,[output_result_dir,'eps_net4.rpt'],'');
durationSet = (duration_one-1)*3600;%(s)
% durationSet = 24*7*3600;%(s)
errcode(2) = calllib(lib_name,'ENsettimeparam',0,durationSet);
errcode(3) = calllib(lib_name,'ENsetoption',0,500);
errcode(4) = calllib(lib_name,'ENopenH');
errcode(5) = calllib(lib_name,'ENinitH',0);
temp_t = 0;
temp_tstep = 1;
time_step_n =0;
% PipeStatus = [pipeStatus];
% [newPipeStatus,temeStepChosen] = pipeStatusChange(PipeStatus);
[~ ,timeStepChose]= pipeStatusChange(PipeStatus);
[newPipeStatusChange ,~]= pipeStatusChange(PipeStatusChange);
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
    [errcode4,temp_tstep]=calllib(lib_name,'ENnextH',temp_tstep);
end


% post-process
errcode(6) = calllib(lib_name,'ENcloseH');
errcode(7) = calllib(lib_name,'ENsaveH');%
errcode(8) = calllib(lib_name,'ENsetstatusreport',2);
errcode(9)= calllib(lib_name,'ENsetreport','NODE ALL'); %
errcode(10) = calllib(lib_name,'ENreport');
errcode(11) = calllib(lib_name,'ENclose');

end

