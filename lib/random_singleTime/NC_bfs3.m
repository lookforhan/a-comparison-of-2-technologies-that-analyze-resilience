
%% 1.本函数根据管线信息（管线编号、起点线号、终点编号）、水源点编号、水池点编号以及全部节点编号，建立邻接矩阵和关联矩阵；通过bfs_mex.mexw32/bfs_mex.mexw64检查管网连通性，并返回孤立节点及管线的编号、位置号。
%% 2.编程思路，程序特点；
%% 3.程序编写人；修改时间：更新内容；
% 韩朝；2017-5-13 19：43；增加文件头部说明；
% 韩朝；2017-6-2 9：43；增加文件头部说明中中间变量说明；输出报告文件名
% 韩朝；2017-6-5 9：43；取代所有全局变量，输入参数由文件读入；
% 韩朝；2017-6-6 9：43；每行增加注释；
% 韩朝；2017-6-16 9：43；ismember代替findmatch；
%% 4.正常运行需要调用的其他自编（自定义）程序（函数）或文件
%% 4.1 程序

%% 4.2 文件

%% 5.调用此程序（函数）的程序？
% 无
%% 6.变量：名称，数据类型，每列（行）数据的含义及单位，输入变量的来源：程序赋值，数据文件读入，调用其他程序（函数）录入；
%% 6.1输入变量
% [1]P,cell,管线编号及起止节点编号,
% [2]R,cell,水源编号,
% [3]C,cell,所有节点编号（包括水源、水池、用户节点）,
% [4]T1,cell,水池编号,
%% 6.2输出变量
% isolated_node_num,double,孤立节点的数量；
% Nid,double,孤立节点的编号
% Nloc,double,孤立节点的位置号
% Pid,double,孤立管线的编号
% Ploc,double,孤立管段的位置号
%% 6.3中间变量
% [1]C1,cell,虚拟水源节点,程序赋值
% [2]C0,cell,所有节点编号,程序赋值
% [3]T,cell,水池节点编号,程序赋值
% [4]pt1,cell,新建管线编号,PcR程序赋值
% [5]pt2,cell,新建管线起点编号,PcR程序赋值
% [6]pt3,cell,新建管线终点编号,PcR程序赋值
% [7]R1,cell,水源编号,程序赋值
% [8]P0,cell,所有管线编号,程序赋值
% [9]Gmatrix,double,关联矩阵,CIM赋值
% [10]A,double,邻接矩阵,CAM赋值
% [11]source_node,double,原点,程序赋值
% [12]dd,double,孤立节点在矩阵中的位置,程序赋值
% [13]num_R,double,水源个数,程序赋值
function [isolated_node_num,Nid,Nloc,Pid,Ploc]=NC_bfs3(P,R,C,T)
C0=C;
P0=P;
if isempty(R)
%     disp('NC_bfs3 无水源')
    n_R_loc=[];
else
    n_R_loc=find(ismember(C0,R)); %水源点位置号
end
if isempty(T)
%     disp('NC_bfs3 无水池')
    n_T_loc=[];
else
    n_T_loc=find(ismember(C0,T)); %水池点位置号
end
%% 建立邻接矩阵和关联矩阵
node_num=numel(C0(:,1));
pipe_num=numel(P0(:,1));
GLmatrix=zeros(pipe_num,node_num); %管网的关联矩阵
LJmatrix=zeros(node_num); %管网的邻接矩阵   
for i=1:pipe_num
    n_h=find(ismember(C0,P0{i,2}));%当前管段的起点位置号
    n_l=find(ismember(C0,P0{i,3}));%当前管段的终点位置号
    GLmatrix(i,n_l)=1;
    GLmatrix(i,n_h)=-1;
    LJmatrix(n_h,n_l)=1;
    LJmatrix(n_l,n_h)=1;
end 
    
%% 虚拟水源点及虚拟邻接矩阵和虚拟关联矩阵
source_node=1; %处理多源点问题的虚拟源点节点位置号
mid_data1=zeros(1,node_num);
mid_data1(n_R_loc)=1;
mid_data1(n_T_loc)=1;
mid_data2=mid_data1';
mid_data3=[0;mid_data2];
LJ=[mid_data1;LJmatrix];
LJ=[mid_data3,LJ];
%% 孤立节点
[dd,~]=bfs_mex(sparse(LJ),source_node,0); %dd为node_num*1的一维向量,在BFS求解返回值为汇点所在的BFS层号，源点的为0，不连通点的为-1
isolated_node=find(dd<0);
if isempty(isolated_node) %不存在孤立节点
    isolated_node_num=0;
    Nid=[];Nloc=[];
    Pid=[];Ploc=[];
else %存在孤立节点
    isolated_node_num=numel(isolated_node);
    isolated_node=isolated_node-1; %去除虚拟源点后的孤立节点位置号；
    Nid=C(isolated_node); % 孤立节点的编号；
    Nloc=isolated_node; %孤立节点的位置号；
%     delete_node_loc=numel(isolated_node_num); %存储每个孤立节点（与源点孤立，但可能存在邻接管段）在关联矩阵中对应的管段位置号
delete_pipe_loc=0;
    for i=1:isolated_node_num
        delete_pipe_loc1=find(GLmatrix(:,isolated_node(i))); %找出孤立节点（与源点孤立，但可能存在邻接管段）在关联矩阵中对应的管段位置号;
        delete_pipe_loc=[delete_pipe_loc;delete_pipe_loc1];
    end
    delete_pipe_loc(1)=[];
    Ploc=unique(delete_pipe_loc);%孤立管段的位置号
    Pid=P0(Ploc); %孤立管段的编号
end
end
