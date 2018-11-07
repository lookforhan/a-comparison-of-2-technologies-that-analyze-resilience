function [ Pressure,Demand,Pattern,Length,system_L_cell,system_serviceability_cell,node_serviceability_cell] = ESP_net_test3( output_net_filename_inp,MC_simulate_result_dir,PipeStatus,pipe_relative,net_data,...
    circulation_num,doa,Hmin,Hdes)
%ESP_net_test 管网延时模拟
%   本函数，目标较小：
%   不涉及关闭管道和打开管道的内容
%   涉及PDD模型运算的内容
%
disp('ESP_net_test2:开始')
mid_t_l = libisloaded('epanet2');
if mid_t_l == 0
    loadlibrary('epanet2.dll','epanet2.h');
end
c=calllib('epanet2','ENopen',output_net_filename_inp,[MC_simulate_result_dir,'\','1.rpt'],[MC_simulate_result_dir,'\','1.out']);
if c~=0
    disp('errors==================');
    disp('ESP_net_test2');
    disp("calllib('epanet2','ENopen',output_net_filename_inp,[MC_simulate_result_dir,'\','1.rpt'],[MC_simulate_result_dir,'\','1.out'])")
    Pressure=0;
    Demand=0;
    Pattern=0;
    Length=0;
    system_L_cell=0;
    system_serviceability_cell=0;
    node_serviceability_cell=0;
    return
end
%==========================================
n_j=0;
n_r=0;
[~,n_j] = calllib('epanet2','ENgetcount',0,n_j);
[~,n_r] = calllib('epanet2','ENgetcount',1,n_r);
junction_num =n_j -n_r;
[~,valuePattern]=Get(junction_num,2);%需水量模式索引
id  =  libpointer('string','id');
len=libpointer('int32Ptr',0);%指针参数--值
value=libpointer('singlePtr',0);%指针参数--值
for i = 1:junction_num
    [~,id]=calllib('epanet2','ENgetpatternid',valuePattern(i),id);%需水量模式id
    pattern_id{i,1}=id;
    [~,len]=calllib('epanet2','ENgetpatternlen',valuePattern(i),len);%需水量模式时段总数
    pattern_len{i,1}=len;
    for j = 1:len
    [~,value]=calllib('epanet2','ENgetpatternvalue',valuePattern(i),j,value);%需水量模式时段总数
    pattern_value{i,j}=value;
    end
    
end
Pattern{1} = valuePattern;
Pattern{2} = pattern_id;
Pattern{3} = pattern_len;
Pattern{4} = pattern_value;
%=========================================
duration = libpointer('longPtr',10);

[c,duration]=calllib('epanet2','ENgettimeparam',0,duration);

if c~=0
    disp('errors==================');
    disp('ESP_net_test2');
    disp("calllib('epanet2','ENgettimeparam',0,duration)")
    Pressure=0;
    Demand=0;
    Pattern=0;
    Length=0;
    system_L_cell=0;
    system_serviceability_cell=0;
    node_serviceability_cell=0;
    return
end
disp(['duration=',num2str(duration)])

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
    time_step_n = time_step_n+1;%计数
    [errcode,temp_t]=calllib('epanet2','ENrunH',temp_t);%计算
    if errcode~=0
        disp('errors==================');
        disp('ESP_net_test2');
        disp("calllib('epanet2','ENrunH',temp_t)")
        Pressure=0;
        Demand=0;
        Pattern=0;
        Length=0;
        system_L_cell=0;
        system_serviceability_cell=0;
        node_serviceability_cell=0;
        return
    end
    %================================================

    %================================================
    [~,based_demand]=Get(junction_num,1);%基础需水量
    [~,real_demand]=Get(junction_num,9);%实际需水量    
    [~,pre]=Get(junction_num,11);%水压
%     Pressure{time_step_n}=pre;
%     Demand{time_step_n}=real_demand./based_demand;
    
    [ pressure_PDD, demand_PDD ] = EPS_PDD1(circulation_num,doa,Hmin,Hdes,net_data,temp_t,real_demand,based_demand);
    %================================================================
    [errcode,temp_tstep]=calllib('epanet2','ENnextH',temp_tstep);
    if errcode~=0
        disp('errors==================');
        disp('ESP_net_test2');
        disp("calllib('epanet2','ENrunH',temp_t)")
        Pressure=0;
        Demand=0;
        Pattern=0;
        Length=0;
        system_L_cell=0;
        system_serviceability_cell=0;
        node_serviceability_cell=0;
        return
    end
    %     disp(num2str(temp_t))
    %     disp(num2str(temp_tstep))
end
disp(['总计时间步：',num2str(time_step_n)])
calllib('epanet2','ENcloseH');
calllib('epanet2','ENsaveH');%保存水力文件
calllib('epanet2','ENsetreport','NODES ALL'); % 设置输出报告的格式
calllib('epanet2','ENreport');
calllib('epanet2','ENclose');
Pressure=0;
Demand=0;
% Pattern=0;
Length=0;
system_L_cell=0;
system_serviceability_cell=0;
node_serviceability_cell=0;
disp('ESP_net_test2:结束')
end

