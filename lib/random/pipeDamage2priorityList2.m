% 20a8-11-15;����
% 2018-1-1������������ע��
%% 2017-12-18
%% ����
%% �����ƻ���Ϣ���ɹܵ��޸�����
%% ���Խ׶���������ɹܵ�����
% BreakPipe_order Ԫ������
function [BreakPipePriority]=pipeDamage2priorityList2(BreakPipe_order)
n=numel(BreakPipe_order);%�����ƻ��ܵ�����
priority=randperm(n)';%�����������
BreakPipePriority_1 = BreakPipe_order(priority);
BreakPipePriority=BreakPipePriority_1;%������ΪԪ������

end