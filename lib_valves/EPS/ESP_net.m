function [ Pressure,Demand,Length,system_L_cell,system_serviceability_cell,node_serviceability_cell] = ESP_net( output_net_filename_inp,MC_simulate_result_dir,PipeStatus,pipe_relative,net_data,...
    circulation_num,doa,Hmin,Hdes)
%ESP_net 管网延时模拟
%   在管网延时模拟中使用PDD模型
system_original_L = sum(cell2mat(net_data{5,2}(:,4)));
mid_t_l = libisloaded('epanet2');
if mid_t_l == 0
    loadlibrary('epanet2.dll','epanet2.h');
end
calllib('epanet2','ENopen',output_net_filename_inp,[MC_simulate_result_dir,'\','1.rpt'],[MC_simulate_result_dir,'\','1.out']);
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
    if numel(PipeStatus(1,:))<temp_t
        mid_t = numel(PipeStatus(1,:));
    end
     for i = 1:numel(PipeStatus(:,mid_t))
        status = PipeStatus(i,mid_t);%mid_t时间下的管道状态。
        switch status                
            case 1 % 如果状态为1，则在修复中，关闭因破坏产生的管道
                n = numel(pipe_relative{i,2});
                for j =1:n
                    id=libpointer('cstring',pipe_relative{i,2}{1,j});
                    index =libpointer('int32Ptr',0);
                    [code,id,index]=calllib('epanet2','ENgetlinkindex',id,index);
                    n=calllib('epanet2','ENsetlinkvalue',index,4,0);
                end
            case 0 %如果状态0，则是完好，则开启该管道。
                id=libpointer('cstring',pipe_relative{i,1});
                %                         id = pipe_relative{i,1};
                index =libpointer('int32Ptr',0);
                [code,id,index]=calllib('epanet2','ENgetlinkindex',id,index);
                n= calllib('epanet2','ENsetlinkvalue',index,4,1);
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [errcode,temp_t]=calllib('epanet2','ENrunH',temp_t);%计算
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
        disp('ESP_NET')
        id = libpointer('cstring','node_id_k');
        value_dem=libpointer('singlePtr',0);%指针参数--值
        calllib('epanet2','ENsaveinpfile','wenti.inp');
        keyboard
        real_demand(find_negative)=0;
        [~,id]=calllib('epanet2','ENgetnodeid',find_negative(1),id)
    end
    [~,real_pre]=Get(junction_num,11);%水压
    [~,real_demand_chosen]=Get_chosen_node_value(original_junction_num,node_id);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [pre,dem] = EPS_PDD(circulation_num,doa,Hmin,Hdes,net_data,temp_t,real_demand,based_demand,real_demand_chosen);
    %     max_time = numel(PipeStatus(1,:));
    Pressure{time_step_n} = pre;
    Demand{time_step_n}=dem;
    len = Get_chosen_link_value(link_id);
    Length{time_step_n}=len;
    system_L_cell{time_step_n}= len/system_original_L;
    mid_loc = find(real_demand_chosen);
    mid_serviceability = ones(numel(dem),1);
    mid_serviceability(mid_loc) = dem(mid_loc)./real_demand_chosen(mid_loc);
    node_serviceability_cell{time_step_n} = mid_serviceability;
    system_serviceability_cell{time_step_n}=sum(dem)/sum(real_demand_chosen);
    if sum(dem)>sum(real_demand_chosen)
        disp('WARNING:==================');
        disp('ESP_NET')
        disp('')
        keyboard
    end
    [errcode,temp_tstep]=calllib('epanet2','ENnextH',temp_tstep);
    disp(num2str(temp_t))
end
calllib('epanet2','ENcloseH');
calllib('epanet2','ENsaveH');%保存水力文件
calllib('epanet2','ENsetreport','NODES ALL'); % 设置输出报告的格式
calllib('epanet2','ENreport');
calllib('epanet2','ENclose');

end

