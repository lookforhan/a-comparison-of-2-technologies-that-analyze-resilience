
%% 1.���������ݹ�����Ϣ�����߱�š�����ߺš��յ��ţ���ˮԴ���š�ˮ�ص����Լ�ȫ���ڵ��ţ������ڽӾ���͹�������ͨ��bfs_mex.mexw32/bfs_mex.mexw64��������ͨ�ԣ������ع����ڵ㼰���ߵı�š�λ�úš�
%% 2.���˼·�������ص㣻
%% 3.�����д�ˣ��޸�ʱ�䣺�������ݣ�
% ������2017-5-13 19��43�������ļ�ͷ��˵����
% ������2017-6-2 9��43�������ļ�ͷ��˵�����м����˵������������ļ���
% ������2017-6-5 9��43��ȡ������ȫ�ֱ���������������ļ����룻
% ������2017-6-6 9��43��ÿ������ע�ͣ�
% ������2017-6-16 9��43��ismember����findmatch��
%% 4.����������Ҫ���õ������Աࣨ�Զ��壩���򣨺��������ļ�
%% 4.1 ����

%% 4.2 �ļ�

%% 5.���ô˳��򣨺������ĳ���
% ��
%% 6.���������ƣ��������ͣ�ÿ�У��У����ݵĺ��弰��λ�������������Դ������ֵ�������ļ����룬�����������򣨺�����¼�룻
%% 6.1�������
% [1]P,cell,���߱�ż���ֹ�ڵ���,
% [2]R,cell,ˮԴ���,
% [3]C,cell,���нڵ��ţ�����ˮԴ��ˮ�ء��û��ڵ㣩,
% [4]T1,cell,ˮ�ر��,
%% 6.2�������
% isolated_node_num,double,�����ڵ��������
% Nid,double,�����ڵ�ı��
% Nloc,double,�����ڵ��λ�ú�
% Pid,double,�������ߵı��
% Ploc,double,�����ܶε�λ�ú�
%% 6.3�м����
% [1]C1,cell,����ˮԴ�ڵ�,����ֵ
% [2]C0,cell,���нڵ���,����ֵ
% [3]T,cell,ˮ�ؽڵ���,����ֵ
% [4]pt1,cell,�½����߱��,PcR����ֵ
% [5]pt2,cell,�½����������,PcR����ֵ
% [6]pt3,cell,�½������յ���,PcR����ֵ
% [7]R1,cell,ˮԴ���,����ֵ
% [8]P0,cell,���й��߱��,����ֵ
% [9]Gmatrix,double,��������,CIM��ֵ
% [10]A,double,�ڽӾ���,CAM��ֵ
% [11]source_node,double,ԭ��,����ֵ
% [12]dd,double,�����ڵ��ھ����е�λ��,����ֵ
% [13]num_R,double,ˮԴ����,����ֵ
function [isolated_node_num,Nid,Nloc,Pid,Ploc]=NC_bfs3(P,R,C,T)
C0=C;
P0=P;
if isempty(R)
%     disp('NC_bfs3 ��ˮԴ')
    n_R_loc=[];
else
    n_R_loc=find(ismember(C0,R)); %ˮԴ��λ�ú�
end
if isempty(T)
%     disp('NC_bfs3 ��ˮ��')
    n_T_loc=[];
else
    n_T_loc=find(ismember(C0,T)); %ˮ�ص�λ�ú�
end
%% �����ڽӾ���͹�������
node_num=numel(C0(:,1));
pipe_num=numel(P0(:,1));
GLmatrix=zeros(pipe_num,node_num); %�����Ĺ�������
LJmatrix=zeros(node_num); %�������ڽӾ���   
for i=1:pipe_num
    n_h=find(ismember(C0,P0{i,2}));%��ǰ�ܶε����λ�ú�
    n_l=find(ismember(C0,P0{i,3}));%��ǰ�ܶε��յ�λ�ú�
    GLmatrix(i,n_l)=1;
    GLmatrix(i,n_h)=-1;
    LJmatrix(n_h,n_l)=1;
    LJmatrix(n_l,n_h)=1;
end 
    
%% ����ˮԴ�㼰�����ڽӾ���������������
source_node=1; %�����Դ�����������Դ��ڵ�λ�ú�
mid_data1=zeros(1,node_num);
mid_data1(n_R_loc)=1;
mid_data1(n_T_loc)=1;
mid_data2=mid_data1';
mid_data3=[0;mid_data2];
LJ=[mid_data1;LJmatrix];
LJ=[mid_data3,LJ];
%% �����ڵ�
[dd,~]=bfs_mex(sparse(LJ),source_node,0); %ddΪnode_num*1��һά����,��BFS��ⷵ��ֵΪ������ڵ�BFS��ţ�Դ���Ϊ0������ͨ���Ϊ-1
isolated_node=find(dd<0);
if isempty(isolated_node) %�����ڹ����ڵ�
    isolated_node_num=0;
    Nid=[];Nloc=[];
    Pid=[];Ploc=[];
else %���ڹ����ڵ�
    isolated_node_num=numel(isolated_node);
    isolated_node=isolated_node-1; %ȥ������Դ���Ĺ����ڵ�λ�úţ�
    Nid=C(isolated_node); % �����ڵ�ı�ţ�
    Nloc=isolated_node; %�����ڵ��λ�úţ�
%     delete_node_loc=numel(isolated_node_num); %�洢ÿ�������ڵ㣨��Դ������������ܴ����ڽӹܶΣ��ڹ��������ж�Ӧ�Ĺܶ�λ�ú�
delete_pipe_loc=0;
    for i=1:isolated_node_num
        delete_pipe_loc1=find(GLmatrix(:,isolated_node(i))); %�ҳ������ڵ㣨��Դ������������ܴ����ڽӹܶΣ��ڹ��������ж�Ӧ�Ĺܶ�λ�ú�;
        delete_pipe_loc=[delete_pipe_loc;delete_pipe_loc1];
    end
    delete_pipe_loc(1)=[];
    Ploc=unique(delete_pipe_loc);%�����ܶε�λ�ú�
    Pid=P0(Ploc); %�����ܶεı��
end
end
