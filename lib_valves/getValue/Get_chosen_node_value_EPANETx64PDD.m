%% ���ָ��id�Ľڵ��ѹ������ˮ��
%% ����
% original_junction_num �ڵ�����
% node_id �ڵ��id
%% ���
% pre ѹ��
% dem ��ˮ��
function [pre,calculate_demand,demand]=Get_chosen_node_value_EPANETx64PDD(lib_name,node_id)
   node_id_k=libpointer('cstring','node_id_k');
    original_junction_num =numel(node_id);
    value_pre=libpointer('doublePtr',0);%ָ�����--ֵ
     value_dem=libpointer('doublePtr',0);%ָ�����--ֵ
     value_req_dem=libpointer('doublePtr',0);%ָ�����--ֵ
     value1=zeros(original_junction_num,1);
     value2=zeros(original_junction_num,1);
     value3=zeros(original_junction_num,1);
        node_index_k1=libpointer('int32Ptr',0);
    for k1=1:original_junction_num
        [code,node_id{k1,1},node_index_k1]=calllib(lib_name,'ENgetnodeindex',node_id{k1,1},node_index_k1);%ָ���ڵ�id��index
        if code>=100
           value1(k1,1)=0;
           value2(k1,1)=0;
           value3(k1,1)=0;
           
           keyboard
        end

        [~,value_pre]=calllib(lib_name,'ENgetnodevalue',node_index_k1,11,value_pre);%index ��ѹ��
        [~,value_dem]=calllib(lib_name,'ENgetnodevalue',node_index_k1,9,value_dem);%index ����ˮ��
        [~,value_req_dem]=calllib(lib_name,'ENgetnodevalue',node_index_k1,110,value_req_dem);%index ����ˮ��
%         [~,value_length]=calllib('epanet2','ENgetnodevalue',node_index_k1,1,value_length);%index ����ˮ��
        [~,node_id_k]=calllib(lib_name,'ENgetnodeid',node_index_k1,node_id_k);
        value1(k1,1)=value_pre;
        value2(k1,1)=value_dem;
        value3(k1,1)=value_req_dem;
%         value3(k1,1)=value_length;
%         clear node_index_k1
    end
    pre=double(value1);
    demand=double(value3);
    calculate_demand = double(value2);
end