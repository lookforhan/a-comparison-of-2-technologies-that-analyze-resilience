% 2018-1-1������������ע��
%% 2017-12-18
%% ����
%% �����ƻ���Ϣ���ɹܵ��޸�����
%% ���Խ׶���������ɹܵ�����
% BreakPipe_order Ԫ������
function [BreakPipePriority]=pipeDamage2priorityList(BreakPipe_order)
n=numel(BreakPipe_order);%�����ƻ��ܵ�����
priority=randperm(n)';%�����������
priority_1=num2cell(priority);%������ת��ΪԪ������
priority_2=[priority_1,BreakPipe_order];%�ϲ�Ϊ����Ԫ������
BreakPipePriority_1=sortrows(priority_2);%�����priority_1��������
BreakPipePriority_1(:,1)=[];%ɾ��������priority_1
BreakPipePriority=BreakPipePriority_1;%������ΪԪ������

end