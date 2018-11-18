%% 1.本函数用来删除存在于破坏管网中的孤立节点及其邻接管段，准备写入破坏管网水力模型inp 文件的数据
%% 2.编程思路，程序特点；
%% 3.程序编写人；修改时间：更新内容；
% 韩朝；2017-5-13 19：43；增加文件头部说明；
% 韩朝；2017-6-2 9：43；增加文件头部说明中中间变量说明；输出报告文件名
% 韩朝；2017-6-5 9：43；取代所有全局变量，输入参数由文件读入；
% 韩朝；2017-6-6 9：43；每行增加注释；
% 韩朝；2017-6-16 9：43；ismember代替findmatch；

%% 4.正常运行需要调用的其他自编（自定义）程序（函数）或文件
%% 4.1 程序
% [1]
%% 4.2 文件
% 无
%% 5.调用此程序（函数）的程序？

%% 6.变量：名称，数据类型，每列（行）数据的含义及单位，输入变量的来源：程序赋值，数据文件读入，调用其他程序（函数）录入；
%% 6.1输入变量
% [0]NID, double,孤立节点的编号；
% [1]Nloc,double,孤立节点位置号,
% [2]Ploc,double,孤立管线位置号,
% [3]pipes,cell,初始管网中管线+破坏管线的属性信息：管线编号(字符串),起点编号(字符串),终点编号(字符串),管线长度(m),管段直径(mm),沿程水头损失摩阻系数,局部水头损失摩阻系数;
% [4]junction,管网中所有新增节点（破坏点+断开增加点）的属性信息：属性信息包含：id(字符串),x,y,Elve(m),type(渗漏1/断开2),pipe(所在管线编号字符串),pipe_index(所在管线位置号),order(所在管线的第几个破坏点),length(相邻破坏点间管段长度比例),Coefficient(如为渗漏点其对应的扩散器系数,转换为LPS流量单位)；
% [5]coordinates,所有节点坐标（包括水源、水池、用户节点+所有新增节点）；
% [6]net_data,cell,初始管网水力模型数据
%% 6.2输出变量
% [1]t,double,t=0表示程序运行无错误
% [2]outdata,cell,删除孤立节点及其邻接管段后的，破坏管网水力模型inp文件所需数据；
%% 6.3中间变量
% [1]num
% [2]num1
% [3]pipes
% [4]old_j
% [5]num3
% [6]old_r
% [7]old_t
% [8]old_d
% [9]old_e
%%
function [t,out]=ND_Out_delete4(NID,Nloc,Ploc,pipes,junction,coordinates,net_data)
out=cell(1,8);%输出变量
%% 删除孤立节点的邻接管线
pipes(Ploc,:)=[];
out{1}=pipes;
%% 管网节点数量统计
isolated_node_num=numel(NID);
original_node_num1=numel(net_data{2,2}(:,1));%用户节点数量
original_node_num2=numel(net_data{3,2}(:,1));%水源节点数量
if isempty(net_data{4,2})
    original_node_num3=0;%水池节点数量
else
    original_node_num3=numel(net_data{4,2}(:,1));%水池节点数量    
end

original_node_num=original_node_num1+original_node_num2+original_node_num3;
% add_node_num=numel(junction(:,1));
% node_num=numel(coordinates(:,1));
% if original_node_num+add_node_num~=node_num %调试检查用
%     disp('节点数量计算不正确！');
%     keyboard;
% end
%% 初始用户节点中删除孤立节点
old_j=net_data{2,2};
mid_loc=ismember(old_j(:,1),NID);
old_j(mid_loc,:)=[];
out{2}=old_j;
%% 新增破坏节点中删除孤立节点
if ~isempty(junction)%新节点
    mid_loc=ismember(junction(:,1),NID);
    junction(mid_loc,:)=[];
    out{3}=junction;
else
    out{3}=[];
end
%% 初始水源节点中删除孤立节点
old_r=net_data{3,2};
if ~isempty(net_data{3,2})
    mid_loc=ismember(old_r(:,1),NID);    
    old_r(mid_loc,:)=[];    
    out{4}=old_r;
else
    out{4}=[];
end
%% 初始水池节点中删除孤立节点
old_t=net_data{4,2};
if ~isempty(net_data{4,2})%旧水池
    mid_loc=ismember(old_t(:,1),NID);
    old_t(mid_loc,:)=[];
    out{5}=old_t;
else
    out{5}=[];
end
%% 初始用户节点需水量中删除孤立节点
if ~isempty(net_data{15,2})%旧需求
    old_d=net_data{15,2};
    mid_loc=ismember(old_d(:,1),NID);
    old_d(mid_loc,:)=[];   
    out{6}=old_d;
else
    out{6}=[];
end
%% 初始管网扩散器中删除孤立节点
old_e=net_data{8,2};
if ~isempty(old_e)%旧扩散
    mid_loc=ismember(old_e(:,1),NID);
    old_e(mid_loc,:)=[];
    out{7}=old_e;
else
    out{7}=[];
end
%% 所有节点（初始（用户，水源，水池）节点+破坏节点）的坐标信息中删除孤立节点
coordinates(Nloc,:)=[];
out{8}=coordinates;
t=0;
end



