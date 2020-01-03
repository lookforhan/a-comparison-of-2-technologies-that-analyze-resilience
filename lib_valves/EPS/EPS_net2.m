function [ errcode,Pressure,Demand,Length,system_L_cell,system_serviceability_cell,node_serviceability_cell,TimeStep,activity_cell] = EPS_net2( output_net_filename_inp,output_result_dir,PipeStatus,pipe_relative,net_data,...
    circulation_num,doa,Hmin,Hdes,duration_one)
%ESP_net 管网延时模拟
%   在管网延时模拟中使用PDD模型
funcName = 'EPS_net2';
if false
    disp([funcName,':开始'])
end
system_original_L = sum(cell2mat(net_data{5,2}(:,4)));
mid_t_l = libisloaded('epanet2');
fid =fopen('EPS_net2记录.txt','w');
% fid = 1;
if mid_t_l == 0
    loadlibrary('epanet2.dll','epanet2.h');
end
t=calllib('epanet2','ENopen',output_net_filename_inp,[output_result_dir,'\','1.rpt'],[output_result_dir,'\','1.out']);
if t~=0
    keyboard
end
%=====================================
% 设置模拟时长
% if duration_one <241
%     duration_one=241;
% end
durationSet = (duration_one-1)*3600;%(s)
% durationSet = 24*7*3600;%(s)
c=calllib('epanet2','ENsettimeparam',0,durationSet);
if c~=0
    disp('errors==================');
    disp([funcName,'错误']);
    disp("calllib('epanet2','ENsettimeparam',0,durationSet)")
    disp(num2str(c));
    errcode = 1;
    Pressure=0;
    Demand=0;
    Length=0;
    system_L_cell=0;
    system_serviceability_cell=0;
    node_serviceability_cell=0;
    TimeStep=0;
    return
end
%=======================================
calllib('epanet2','ENopenH');
code = calllib('epanet2','ENinitH',1);
temp_t =0;
temp_tstep =1;
time_step_n=0;
node_id = net_data{2,2}(:,1);
original_junction_num = numel(node_id);
link_id = net_data{5,2}(:,1);
% key_flag = 0;
[newPipeStatus ,timeStepChose]= pipeStatusChange(PipeStatus);

while (temp_tstep && ~code)
    time_step_n = time_step_n+1;
    mid_t = floor(double(temp_t+temp_tstep)/3600)+1;
    [lia,loc] = ismember(mid_t,timeStepChose);
    if lia
        fprintf(fid,'%s\r\n','开始修改管道状态');
        str1 = '';
        str2 ='';
        str3 = '';
        mid_status = newPipeStatus(:,loc);
        for i = 1:numel(mid_status)
            pipe_status = mid_status(i);
            switch  pipe_status
                case 2
                    continue %该管道没有修复
                case 1
                    %管道隔离
                    str2 = [str2,'隔离管道',pipe_relative{i,1},';'];
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
                    str3 = [str3,'修复管道',pipe_relative{i,1},';'];
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
        str = [str1,str2,str3];
    else
        str = '无动作';
        fprintf(fid,'%s时刻,无需修改管道状态\r\n',num2str(temp_t) );
    end
    
    
    %     calllib('epanet2','ENsaveinpfile','wenti2.inp');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [code,temp_t]=calllib('epanet2','ENrunH',temp_t);%计算
    n_j =0;
    n_r=0;
    [c,n_j] = calllib('epanet2','ENgetcount',0,n_j);
    [c,n_r] = calllib('epanet2','ENgetcount',1,n_r);
    junction_num =n_j -n_r;
    [~,based_demand]=Get(junction_num,1);%实际需水量
    [~,real_demand]=Get(junction_num,9);%实际需水量
    find_negative = find(real_demand<0);
    if any(find_negative)
        disp('WARNING:==================');
        disp([funcName,'错误'])
        id = libpointer('cstring','node_id_k');
        value_dem=libpointer('singlePtr',0);%指针参数--值
        calllib('epanet2','ENsaveinpfile','wenti.inp');
        real_demand(find_negative)=0;
        [~,id]=calllib('epanet2','ENgetnodeid',find_negative(1),id)
        errcode = 1;
        keyboard
    end
    [~,real_pre]=Get(junction_num,11);%水压
    [~,real_demand_chosen]=Get_chosen_node_value(original_junction_num,node_id);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %===========================================================
    % 调用EPS_PDD2
    [pre,dem] = EPS_PDD4(circulation_num,doa,Hmin,Hdes,net_data,temp_t,real_demand,based_demand,real_demand_chosen);
    %     [pre1,dem1] = EPS_PDD2(circulation_num,doa,Hmin,Hdes,net_data,temp_t,real_demand,based_demand,real_demand_chosen);
    %===========================================================
    %     max_time = numel(PipeStatus(1,:));
    %     temp_t_double = double(temp_t);
    %     Pressure{time_step_n,1} = temp_t_double;
    %     Pressure{time_step_n,2} = double(pre);
    %     Demand{time_step_n,1}=temp_t_double;
    %     Demand{time_step_n,2}=double(dem);
    %     len = Get_chosen_link_value(link_id);
    %     Length{time_step_n,1}=temp_t_double;
    %     Length{time_step_n,2}=len;
    %     system_L_cell{time_step_n,1}= temp_t_double;
    %     system_L_cell{time_step_n,2}= double(len/system_original_L);
    %     mid_loc = find(real_demand_chosen);
    %     mid_serviceability = ones(numel(dem),1);
    %     mid_serviceability(mid_loc) = dem(mid_loc)./real_demand_chosen(mid_loc);
    %     node_serviceability_cell{time_step_n,1} = temp_t_double;
    %     node_serviceability_cell{time_step_n,2} = double(mid_serviceability);
    %     system_serviceability_cell{time_step_n,1}=temp_t_double;
    %     system_serviceability_cell{time_step_n,2}=double(sum(dem)/sum(real_demand_chosen));
    time_step_n_cell{time_step_n} =time_step_n;
    temp_t_double = double(temp_t);
    TimeStep{time_step_n} =temp_t_double;
    activity_cell{time_step_n} = str;%记录每个时间步的行为
    %     Pressure{time_step_n,1} = temp_t_double;
    Pressure{time_step_n} = double(pre);
    %     Demand{time_step_n,1}=temp_t_double;
    Demand{time_step_n}=double(dem);
    len = Get_chosen_link_value(link_id);
    %     Length{time_step_n,1}=temp_t_double;
    Length{time_step_n}=len;
    %     system_L_cell{time_step_n,1}= temp_t_double;
    system_L_cell{time_step_n}= double(len/system_original_L);
    mid_loc = find(real_demand_chosen);
    mid_serviceability = ones(numel(dem),1);
    mid_serviceability(mid_loc) = dem(mid_loc)./real_demand_chosen(mid_loc);
    %     node_serviceability_cell{time_step_n,1} = temp_t_double;
    node_serviceability_cell{time_step_n} = double(mid_serviceability);
    %     system_serviceability_cell{time_step_n,1}=temp_t_double;
    system_serviceability_cell{time_step_n}=double(sum(dem)/sum(real_demand_chosen));
    real_demand_chosen_cell{time_step_n} = real_demand_chosen;
    if sum(dem)>sum(real_demand_chosen)
        disp('WARNING:==================');
        disp([funcName,'错误'])
        disp('')
        keyboard
        errcode = 3;
        [pre,dem] = EPS_PDD4(circulation_num,doa,Hmin,Hdes,net_data,temp_t,real_demand,based_demand,real_demand_chosen);
        %           [pre1,dem1] = EPS_PDD2(circulation_num,doa,Hmin,Hdes,net_data,temp_t,real_demand,based_demand,real_demand_chosen);
    end
    [code,temp_tstep]=calllib('epanet2','ENnextH',temp_tstep);
    
end
calllib('epanet2','ENcloseH');
calllib('epanet2','ENsaveH');%保存水力文件
calllib('epanet2','ENsetreport','NODES ALL'); % 设置输出报告的格式
calllib('epanet2','ENreport');
calllib('epanet2','ENclose');
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
fclose(fid);
errcode =0;
end

