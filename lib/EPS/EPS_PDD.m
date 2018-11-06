function [ pressure_PDD, demand_PDD ] = EPS_PDD(circulation_num,doa,Hmin,Hdes,net_data,temp_t,real_demand,based_demand,real_demand_chosen)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
node_id = net_data{2,2}(:,1);
original_junction_num = numel(node_id);
% [o_pre,o_dem]=Get_chosen_node_value(original_junction_num,node_id);
n_j =0;
n_r=0;
[c,n_j] = calllib('epanet2','ENgetcount',0,n_j);
[c,n_r] = calllib('epanet2','ENgetcount',1,n_r);
junction_num =n_j -n_r;
C_mid=ones(junction_num,1);
HMIN=Hmin*C_mid;HDES=Hdes*C_mid;two=2*C_mid;
% [~,bdemand]=Get(junction_num,9);%实际需水量
value=libpointer('singlePtr',0);%指针参数--值
for i = 1:circulation_num
    calllib('epanet2','ENrunH',temp_t);% 运行水力计算
    [~,pre]=Get(junction_num,11);%压力
%     [~,bdemand0]=Get(junction_num,9);%实际需水量
bdemand1 = real_demand;
    bdemand2=bdemand1;%bdemand2作为中间变量
    
    bdemand1(pre<=Hmin)=0;
    [i2]=find(pre(:,1)>=Hmin&pre(:,1)<=Hdes);
    bdemand1(i2,1)=(bdemand1(i2,1)+real_demand(i2,1).*((pre(i2,1)-HMIN(i2,1))./(HDES(i2,1)-HMIN(i2,1))).^(1/2))./two(i2,1);
    compare_dem = gt(bdemand1,real_demand);
%     if any(compare_dem)
%         keyboard
%     end
    error=abs(bdemand1-bdemand2)-abs(doa*bdemand2);
    b=max(error);
    if b<0.01
        disp(['PDD满足收敛条件,迭代',num2str(i),'次'])
        break
    end
    %----------%将处理后需水量输入EPA
    period1 = rem(temp_t/3600,168);
    period=ceil(period1);
    if period==0
        period=1;
    end
    for j=1:junction_num
        [c,value]=calllib('epanet2','ENgetnodevalue',j,2,value);
        index = value;
        
        [c,value]=calllib('epanet2','ENgetpatternvalue',index,period,value);
        if value == 0
            bdemand5=bdemand1(j,1);
        else
        bdemand5=bdemand1(j,1)/value;
        end
        calllib('epanet2','ENsetnodevalue',j,1,bdemand5);
    end
%     [c,value1]=calllib('epanet2','ENgetnodevalue',1,9,value);
end
[out_pre,out_demand]=Get_chosen_node_value(original_junction_num,node_id);
if sum(out_demand)>sum(real_demand_chosen)
    keyboard
end
pressure_PDD=out_pre;
demand_PDD=out_demand;
for j=1:junction_num    
    calllib('epanet2','ENsetnodevalue',j,1,based_demand(j,1));
end
end

