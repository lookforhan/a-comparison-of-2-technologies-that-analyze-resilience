function [ pressure_PDD, demand_PDD ] = EPS_PDD3(circulation_num,doa,Hmin,Hdes,net_data,temp_t,real_demand,based_demand,real_demand_chosen)
%UNTITLED4 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
funcName = 'EPS_PDD3';
% disp([funcName,'��ʼ'])
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
% [~,bdemand]=Get(junction_num,9);%ʵ����ˮ��
value=libpointer('singlePtr',0);%ָ�����--ֵ
for i = 1:circulation_num
    calllib('epanet2','ENrunH',temp_t);% ����ˮ������
    [~,pre]=Get(junction_num,11);%ѹ��
    [~,bdemand_i]=Get(junction_num,9);%ʵ����ˮ��
    [~,bdemand_0]=Get(junction_num,1);%������ˮ��
    multiplier = bdemand_i./bdemand_0;
%     bdemand2=bdemand1;%bdemand2��Ϊ�м����
    bdemand_ii=bdemand_i;
    bdemand_ii(pre<=Hmin)=0;
    [i2]=find(pre(:,1)>=Hmin&pre(:,1)<=Hdes);
    bdemand_ii(i2,1)=0.5*(bdemand_i(i2,1)+(real_demand(i2,1).*((pre(i2,1)-HMIN(i2,1))./(HDES(i2,1)-HMIN(i2,1))).^(1/2)));%Wagner��ˮ���ۼ���ʽ��
%     calllib('epanet2','ENsaveinpfile','wenti2.inp'); 
    

    %----------%���������ˮ������EPA

    for j=1:junction_num
        if isnan(multiplier(j))
            bdemand5 = 0;
        else
            bdemand5 = bdemand_ii(j)/multiplier(j);
        end

        calllib('epanet2','ENsetnodevalue',j,1,bdemand5);
    end
%     [c,value1]=calllib('epanet2','ENgetnodevalue',1,9,value);
%     [~,bdemand0]=Get(junction_num,9);%ʵ����ˮ��
%     [~,bdemand0]=Get(junction_num,1);%ʵ����ˮ��
    error=abs(bdemand_ii-bdemand_i)./bdemand_i;
    b=max(abs(error));
    if b<doa
%         disp(['PDD������������,����',num2str(i),'��'])
        break
    end
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

