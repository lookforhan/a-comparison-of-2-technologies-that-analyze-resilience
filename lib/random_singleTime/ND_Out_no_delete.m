%% 1.�������Ĺ��ܣ�Ϊ����ɾ�������ڵ�ʱ������ˮ��ģ�����ݸ�ʽ��׼��д���ƻ�����ˮ��ģ��inp �ļ�������
%% 2.���˼·�������ص㣻
%% 3.�����д�ˣ��޸�ʱ�䣺�������ݣ�
% ������2017-5-13 19��43�������ļ�ͷ��˵����
% ������2017-6-2 9��43�������ļ�ͷ��˵�����м����˵������������ļ���
% ������2017-6-5 9��43��ȡ������ȫ�ֱ���������������ļ����룻
% ������2017-6-6 9��43��ÿ������ע�ͣ�

%% 4.����������Ҫ���õ������Աࣨ�Զ��壩���򣨺��������ļ�
%% 4.1 ����
% [1]
%% 4.2 �ļ�
% ��
%% 5.���ô˳��򣨺������ĳ���
% [1]data_pipe
% [2]data_new_node
% [3]dataC1
% [4]net_data

%% 6.���������ƣ��������ͣ�ÿ�У��У����ݵĺ��弰��λ�������������Դ������ֵ�������ļ����룬�����������򣨺�����¼�룻
%% 6.1�������
% [1]out
%% 6.2�������
% [1]t,double,t=0��ʾ���������޴���
% [2]outdata,cell,����ˮ��ģ������
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
function [t,outdata]=ND_Out_no_delete(data_pipe,data_new_node,dataC1,net_data)
outdata{1}=data_pipe;%�ܵ�
if ~isempty(net_data{2,2})%
    outdata{2}=net_data{2,2};%ԭ�ڵ�
else
    outdata{2}=[];
end
if ~isempty(data_new_node)%�½ڵ�
    outdata{3}=data_new_node;
else
    outdata{3}=[];
end
if ~isempty(net_data{3,2})%ˮԴ
    outdata{4}=net_data{3,2};
else
    outdata{4}=[];
end
if ~isempty(net_data{4,2})%ˮ��
    outdata{5}=net_data{4,2};
else
    outdata{5}=[];
end
if ~isempty(net_data{15,2})%demand
    outdata{6}=net_data{15,2};
else
    outdata{6}=[];
end
if ~isempty(net_data{8,2})%emitters
    outdata{7}=net_data{8,2};
else
    outdata{7}=[];
end
outdata{8}=dataC1;
t=0;
end