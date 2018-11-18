function [ node_original_data ] = get_node_value( inpfile,libName )
%get_node_value �˴���ʾ�йش˺�����ժҪ
%   �˺�����Ҫ�ȼ��ض�̬���ӿ�epanet2.dll
%   ����ڵ��id / ��ˮ��/ѹ��
funcName = 'get_node_value';
t=calllib(libName,'ENopen',inpfile,'high.rpt','high.out');
code=calllib(libName,'ENsolveH');% ����ˮ������
calllib(libName,'ENsaveH');% ����
count=libpointer('int32Ptr',0);%ָ�����--�������м����
[~,count_node]=calllib(libName,'ENgetcount',0,count);%ȫ���ڵ����
[~,count_tank]=calllib(libName,'ENgetcount',1,count);%ˮ�غ�ˮ������
original_junction_num=count_node-count_tank;%�û��ڵ����
node_original_data=cell(original_junction_num,3);%�ڵ�id�ͳ�ʼ��ˮ��
node_original_dem=zeros(original_junction_num,1);
node_original_pre=zeros(original_junction_num,1);
node_id_k=libpointer('cstring','node_id_k');
value_dem=libpointer('singlePtr',0);
value_pre=libpointer('singlePtr',0);
for k=1:original_junction_num
    [~,node_id_k]=calllib(libName,'ENgetnodeid',k,node_id_k);
    node_original_data{k,1}=node_id_k;
    [~,value_dem]=calllib(libName,'ENgetnodevalue',k,1,value_dem);
    node_original_data{k,2}=value_dem;
    node_original_dem(k)=value_dem;
    [~,value_pre]=calllib(libName,'ENgetnodevalue',k,11,value_pre);
    node_original_data{k,3}=value_pre;
    node_original_pre(k)=value_pre;
end
calllib(libName,'ENclose'); %�رռ���


end

