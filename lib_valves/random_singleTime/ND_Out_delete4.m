%% 1.����������ɾ���������ƻ������еĹ����ڵ㼰���ڽӹܶΣ�׼��д���ƻ�����ˮ��ģ��inp �ļ�������
%% 2.���˼·�������ص㣻
%% 3.�����д�ˣ��޸�ʱ�䣺�������ݣ�
% ������2017-5-13 19��43�������ļ�ͷ��˵����
% ������2017-6-2 9��43�������ļ�ͷ��˵�����м����˵������������ļ���
% ������2017-6-5 9��43��ȡ������ȫ�ֱ���������������ļ����룻
% ������2017-6-6 9��43��ÿ������ע�ͣ�
% ������2017-6-16 9��43��ismember����findmatch��

%% 4.����������Ҫ���õ������Աࣨ�Զ��壩���򣨺��������ļ�
%% 4.1 ����
% [1]
%% 4.2 �ļ�
% ��
%% 5.���ô˳��򣨺������ĳ���

%% 6.���������ƣ��������ͣ�ÿ�У��У����ݵĺ��弰��λ�������������Դ������ֵ�������ļ����룬�����������򣨺�����¼�룻
%% 6.1�������
% [0]NID, double,�����ڵ�ı�ţ�
% [1]Nloc,double,�����ڵ�λ�ú�,
% [2]Ploc,double,��������λ�ú�,
% [3]pipes,cell,��ʼ�����й���+�ƻ����ߵ�������Ϣ�����߱��(�ַ���),�����(�ַ���),�յ���(�ַ���),���߳���(m),�ܶ�ֱ��(mm),�س�ˮͷ��ʧĦ��ϵ��,�ֲ�ˮͷ��ʧĦ��ϵ��;
% [4]junction,���������������ڵ㣨�ƻ���+�Ͽ����ӵ㣩��������Ϣ��������Ϣ������id(�ַ���),x,y,Elve(m),type(��©1/�Ͽ�2),pipe(���ڹ��߱���ַ���),pipe_index(���ڹ���λ�ú�),order(���ڹ��ߵĵڼ����ƻ���),length(�����ƻ����ܶγ��ȱ���),Coefficient(��Ϊ��©�����Ӧ����ɢ��ϵ��,ת��ΪLPS������λ)��
% [5]coordinates,���нڵ����꣨����ˮԴ��ˮ�ء��û��ڵ�+���������ڵ㣩��
% [6]net_data,cell,��ʼ����ˮ��ģ������
%% 6.2�������
% [1]t,double,t=0��ʾ���������޴���
% [2]outdata,cell,ɾ�������ڵ㼰���ڽӹܶκ�ģ��ƻ�����ˮ��ģ��inp�ļ��������ݣ�
%% 6.3�м����
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
out=cell(1,8);%�������
%% ɾ�������ڵ���ڽӹ���
pipes(Ploc,:)=[];
out{1}=pipes;
%% �����ڵ�����ͳ��
isolated_node_num=numel(NID);
original_node_num1=numel(net_data{2,2}(:,1));%�û��ڵ�����
original_node_num2=numel(net_data{3,2}(:,1));%ˮԴ�ڵ�����
if isempty(net_data{4,2})
    original_node_num3=0;%ˮ�ؽڵ�����
else
    original_node_num3=numel(net_data{4,2}(:,1));%ˮ�ؽڵ�����    
end

original_node_num=original_node_num1+original_node_num2+original_node_num3;
% add_node_num=numel(junction(:,1));
% node_num=numel(coordinates(:,1));
% if original_node_num+add_node_num~=node_num %���Լ����
%     disp('�ڵ��������㲻��ȷ��');
%     keyboard;
% end
%% ��ʼ�û��ڵ���ɾ�������ڵ�
old_j=net_data{2,2};
mid_loc=ismember(old_j(:,1),NID);
old_j(mid_loc,:)=[];
out{2}=old_j;
%% �����ƻ��ڵ���ɾ�������ڵ�
if ~isempty(junction)%�½ڵ�
    mid_loc=ismember(junction(:,1),NID);
    junction(mid_loc,:)=[];
    out{3}=junction;
else
    out{3}=[];
end
%% ��ʼˮԴ�ڵ���ɾ�������ڵ�
old_r=net_data{3,2};
if ~isempty(net_data{3,2})
    mid_loc=ismember(old_r(:,1),NID);    
    old_r(mid_loc,:)=[];    
    out{4}=old_r;
else
    out{4}=[];
end
%% ��ʼˮ�ؽڵ���ɾ�������ڵ�
old_t=net_data{4,2};
if ~isempty(net_data{4,2})%��ˮ��
    mid_loc=ismember(old_t(:,1),NID);
    old_t(mid_loc,:)=[];
    out{5}=old_t;
else
    out{5}=[];
end
%% ��ʼ�û��ڵ���ˮ����ɾ�������ڵ�
if ~isempty(net_data{15,2})%������
    old_d=net_data{15,2};
    mid_loc=ismember(old_d(:,1),NID);
    old_d(mid_loc,:)=[];   
    out{6}=old_d;
else
    out{6}=[];
end
%% ��ʼ������ɢ����ɾ�������ڵ�
old_e=net_data{8,2};
if ~isempty(old_e)%����ɢ
    mid_loc=ismember(old_e(:,1),NID);
    old_e(mid_loc,:)=[];
    out{7}=old_e;
else
    out{7}=[];
end
%% ���нڵ㣨��ʼ���û���ˮԴ��ˮ�أ��ڵ�+�ƻ��ڵ㣩��������Ϣ��ɾ�������ڵ�
coordinates(Nloc,:)=[];
out{8}=coordinates;
t=0;
end



