%% 获得指定id的节点的压力与需水量
%% 输入
% original_junction_num 节点总数
% node_id 节点的id
%% 输出
% pre 压力
% dem 需水量
function [pre,demand,calculatedemand]=Get_chosen_node_value_EPANETx64PDD(lib_name,node_id)
   node_id_k=libpointer('cstring','node_id_k');
    original_junction_num =numel(node_id);
    value_pre=libpointer('doublePtr',0);%指针参数--值
     value_dem=libpointer('doublePtr',0);%指针参数--值
     value_cal_dem=libpointer('doublePtr',0);%指针参数--值
     value1=zeros(original_junction_num,1);
     value2=zeros(original_junction_num,1);
    for k1=1:original_junction_num
        node_index_k1=libpointer('int32Ptr',0);
        node_id_k1=libpointer('cstring',node_id{k1,1});
        [code,node_id_k1,node_index_k1]=calllib(lib_name,'ENgetnodeindex',node_id_k1,node_index_k1);%指定节点id的index
        if code~=0
           value1(k1,1)=0;
           value2(k1,1)=0;
%            value3(k1,1)=0;
           continue
        end

        [~,value_pre]=calllib(lib_name,'ENgetnodevalue',node_index_k1,11,value_pre);%index 的压力
        [~,value_dem]=calllib(lib_name,'ENgetnodevalue',node_index_k1,9,value_dem);%index 的需水量
        [~,value_cal_dem]=calllib(lib_name,'ENgetnodevalue',node_index_k1,110,value_cal_dem);%index 的需水量
%         [~,value_length]=calllib('epanet2','ENgetnodevalue',node_index_k1,1,value_length);%index 的需水量
        [~,node_id_k]=calllib(lib_name,'ENgetnodeid',node_index_k1,node_id_k);
        value1(k1,1)=value_pre;
        value2(k1,1)=value_dem;
        value3(k1,1)=value_cal_dem;
%         value3(k1,1)=value_length;
%         clear node_index_k1
    end
    pre=double(value1);
    demand=double(value2);
    calculatedemand = double(value3);
end