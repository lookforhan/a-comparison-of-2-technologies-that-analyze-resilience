function [ pressure_PDD, demand_PDD ] = EPS_PDD4(circulation_num,doa,Hmin,Hdes,net_data,temp_t,real_demand,based_demand,real_demand_chosen)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
funcName = 'EPS_PDD2';
% disp([funcName,'开始'])
node_id = net_data{2,2}(:,1);
original_junction_num = numel(node_id);
len  = libpointer('int32Ptr',0);
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
calllib('epanet2','ENrunH',temp_t);% 运行水力计算
[~,pre]=Get(junction_num,11);%压力
[~,bdemand_i]=Get(junction_num,9);%实际需水量
[~,bdemand_0]=Get(junction_num,1);%基础需水量
multiplier1 = bdemand_i./bdemand_0;
for i = 1:circulation_num
    calllib('epanet2','ENrunH',temp_t);% 运行水力计算
    [~,pre]=Get(junction_num,11);%压力
    [~,bdemand_i]=Get(junction_num,9);%实际需水量
  [ bdemand_ii ] = pdd_HBW( bdemand_i,real_demand,pre,Hmin,Hdes,0.3 )  ;

    %----------%将处理后需水量输入EPA
    
    for j=1:junction_num
        [c,value]=calllib('epanet2','ENgetnodevalue',j,2,value);
        index = value;
        if index
            [~,len]=calllib('epanet2','ENgetpatternlen',index,len);%需水量模式时段总数
            period1 = rem(double(temp_t)/3600,double(len));
            period=floor(period1)+1;
            [c,value]=calllib('epanet2','ENgetpatternvalue',index,period,value);
            multiplier2(j,1) = double(value);
            if value == 0
                bdemand5=0;
                keyboard
            else
                bdemand5=bdemand_ii(j)/value;
            end
        else
            bdemand5=bdemand_ii(j);
        end
        
        
        calllib('epanet2','ENsetnodevalue',j,1,bdemand5);
    end
    %     [c,value1]=calllib('epanet2','ENgetnodevalue',18,9,value);
    %     [~,bdemand0]=Get(junction_num,9);%实际需水量
    i3 = find(bdemand_i==0);
    i4 =find(bdemand_i~=0);
    error = bdemand_i;
    if i3
        error(i4) = abs(bdemand_ii(i4)-bdemand_i(i4))./bdemand_i(i4);
        error(i3) = abs(bdemand_ii(i3)-bdemand_i(i3));
        
    else
        error=abs(bdemand_ii-bdemand_i)./bdemand_i;
    end
    b=max(abs(error));
    if b<0.01
        %         disp(['PDD满足收敛条件,迭代',num2str(i),'次'])
        break
    end
    if i==circulation_num-4
        %         keyboard
    end
end
[out_pre,out_demand]=Get_chosen_node_value(original_junction_num,node_id);
if sum(out_demand)>sum(real_demand_chosen)
    multiplier=[multiplier1,multiplier2]
    demand = [out_demand,real_demand_chosen]
    keyboard
end
pressure_PDD=out_pre;
demand_PDD=out_demand;
for j=1:junction_num
    calllib('epanet2','ENsetnodevalue',j,1,based_demand(j,1));
end
end

