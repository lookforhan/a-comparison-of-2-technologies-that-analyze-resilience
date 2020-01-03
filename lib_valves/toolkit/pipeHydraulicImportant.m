function [ output_args ] = pipeHydraulicImportant( file_in )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

t = libisloaded('epanet2');
if t==0
loadlibrary('C:\Users\dell\Documents\toolbox\epanet2','C:\Users\dell\Documents\toolbox\epanet2.h')
end
% input_net_filename = 'C:\Users\hc042\Desktop\韧性\matlab代码\运算案例\GWSL_4.inp';
input_net_filename = file_in;
Before_Earthq_rpt='net.rpt';
Before_Earthq_out='net.out';
code=calllib('epanet2','ENopen',input_net_filename,Before_Earthq_rpt,Before_Earthq_out);% 打开管网数据文件
code=calllib('epanet2','ENsolveH');% 运行水力计算
calllib('epanet2','ENsaveH');% 保存
count=libpointer('int32Ptr',0);%指针参数--计数，中间变量
[~,count_node]=calllib('epanet2','ENgetcount',0,count);%全部节点个数
[~,count_tank]=calllib('epanet2','ENgetcount',1,count);%水池和水厂个数
original_junction_num=count_node-count_tank;%用户节点个数
node_original_data=cell(original_junction_num,3);%节点id和初始需水量
node_original_dem=zeros(original_junction_num,1);
node_original_pre=zeros(original_junction_num,1);
node_id_k=libpointer('cstring','node_id_k');
value_dem=libpointer('singlePtr',0);
value_pre=libpointer('singlePtr',0);
for k=1:original_junction_num
    [~,node_id_k]=calllib('epanet2','ENgetnodeid',k,node_id_k);
    node_original_data{k,1}=node_id_k;
    [~,value_dem]=calllib('epanet2','ENgetnodevalue',k,1,value_dem);
    node_original_data{k,2}=value_dem;
    node_original_dem(k)=value_dem;
    [~,value_pre]=calllib('epanet2','ENgetnodevalue',k,11,value_pre);
    node_original_data{k,3}=value_pre;
    node_original_pre(k)=value_pre;
end
%% 开始关闭管道
[~,count_pipe]=calllib('epanet2','ENgetcount',2,count);%全部管道个数
Hj = cell(1,count_pipe);
junction_num=original_junction_num;
I = zeros(1,count_pipe);
for i = 1:count_pipe
    internal_inpfile = ['net',num2str(i),'.inp'];
    calllib('epanet2','ENsetlinkvalue',i,4,0);
%     calllib('epanet2','ENsaveinpfile',internal_inpfile);
    code=calllib('epanet2','ENsolveH');% 运行水力计算
calllib('epanet2','ENsaveH');% 保存
[~,pre]=Get(junction_num,11);%压力
Hj{1,i} =pre;
I(1,i) = sum(node_original_pre-pre)/double(original_junction_num);
calllib('epanet2','ENsetlinkvalue',i,4,1);
end
output_args = I;
calllib('epanet2','ENclose');
unloadlibrary epanet2

end

