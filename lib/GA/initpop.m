% 2018-1-1����������ʼ��Ⱥ�а����ܵ�������
%% ���� hanzhao@emails.bjut.edu.cn
%% 2017-12-19
% initpop.m�����Ĺ�����ʵ��Ⱥ��ĳ�ʼ����popsize��ʾȺ��Ĵ�С��
% ���ȴ�Сȡ���ڱ����Ķ����Ʊ���ĳ���(�ڱ�����ȡ10λ)��
%�Ŵ��㷨�ӳ���
%Name: initpop.m
%��ʼ��
% popsize ��Ⱥ��С��
% BreakPipe_order �ƻ��ܵ�
function pop=initpop(popsize,BreakPipe_order)
pop=cell(popsize,1);%�����޸������һ
for i=1:popsize
[pop{i,1}]=pipeDamage2priorityList(BreakPipe_order);%�����޸�����
end
end