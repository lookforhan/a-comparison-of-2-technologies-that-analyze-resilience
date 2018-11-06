function [ node_original_data ] = get_node_value( inpfile,libName )
%get_node_value 此处显示有关此函数的摘要
%   此函数需要先加载动态链接库epanet2.dll
%   输出节点的id / 需水量/压力
funcName = 'get_node_value';
t=calllib(libName,'ENopen',inpfile,'high.rpt','high.out');
code=calllib(libName,'ENsolveH');% 运行水力计算
calllib(libName,'ENsaveH');% 保存
count=libpointer('int32Ptr',0);%指针参数--计数，中间变量
[~,count_node]=calllib(libName,'ENgetcount',0,count);%全部节点个数
[~,count_tank]=calllib(libName,'ENgetcount',1,count);%水池和水厂个数
original_junction_num=count_node-count_tank;%用户节点个数
node_original_data=cell(original_junction_num,3);%节点id和初始需水量
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
calllib(libName,'ENclose'); %关闭计算


end

