function [ Pressure,Demand,real_pattern,Length,system_L_cell,system_serviceability_cell,node_serviceability_cell] = ESP_net_test1( output_net_filename_inp,MC_simulate_result_dir,PipeStatus,pipe_relative,net_data,...
    circulation_num,doa,Hmin,Hdes)
%ESP_net_test 管网延时模拟
%   本函数，目标较小：
%   不涉及关闭管道和打开管道的内容
%   不涉及PDD模型运算的内容
%
system_original_L = sum(cell2mat(net_data{5,2}(:,4)));
mid_t_l = libisloaded('epanet2');
if mid_t_l == 0
    loadlibrary('epanet2.dll','epanet2.h');
end
c=calllib('epanet2','ENopen',output_net_filename_inp,[MC_simulate_result_dir,'\','1.rpt'],[MC_simulate_result_dir,'\','1.out']);
duration = libpointer('longPtr',10);
id  =  libpointer('string','id');
[c,duration]=calllib('epanet2','ENgettimeparam',0,duration);
disp('duration')
disp(num2str(duration));
calllib('epanet2','ENopenH');
calllib('epanet2','ENinitH',1);
temp_t =0;
temp_tstep =1;
time_step_n=0;
node_id = net_data{2,2}(:,1);
original_junction_num = numel(node_id);
link_id = net_data{5,2}(:,1);
% key_flag = 0;
while temp_tstep
    time_step_n = time_step_n+1;
    if temp_t ==0
        mid_t =1;
    else
        mid_t = temp_t;
    end
    [errcode,temp_t]=calllib('epanet2','ENrunH',temp_t);%计算
    n_j =0;
    n_r=0;
    [c,n_j] = calllib('epanet2','ENgetcount',0,n_j);
    [c,n_r] = calllib('epanet2','ENgetcount',1,n_r);
    junction_num =n_j -n_r;
    [~,based_demand]=Get(junction_num,1);%基础需水量
    [~,real_demand]=Get(junction_num,9);%实际需水量
    
    [~,pre]=Get(junction_num,11);%水压
    Pressure{time_step_n}=pre;
     Demand{time_step_n}=real_demand./based_demand;
     
     
    %================================================================
    [errcode,temp_tstep]=calllib('epanet2','ENnextH',temp_tstep);
    disp(num2str(temp_t))
end
calllib('epanet2','ENcloseH');
calllib('epanet2','ENsaveH');%保存水力文件
calllib('epanet2','ENsetreport','NODES ALL'); % 设置输出报告的格式
calllib('epanet2','ENreport');
calllib('epanet2','ENclose');
% Pressure=0;
% Demand=0;
real_pattern=0;
Length=0;
system_L_cell=0;
system_serviceability_cell=0;
node_serviceability_cell=0;
end

