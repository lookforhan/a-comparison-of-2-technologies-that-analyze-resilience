% 2018-1-1����������ʼ��Ⱥ�а����ܵ�������
%% ���� hanzhao@emails.bjut.edu.cn
%% 2017-12-19
% initpop.m�����Ĺ�����ʵ��Ⱥ��ĳ�ʼ����popsize��ʾȺ��Ĵ�С��chromlength��ʾȾɫ��ĳ���(��ֵ���ĳ���)��
% ���ȴ�Сȡ���ڱ����Ķ����Ʊ���ĳ���(�ڱ�����ȡ10λ)��
%�Ŵ��㷨�ӳ���
%Name: initpop.m
%��ʼ����Ⱥ
% pop=initpop2(20,{1;4;2;3;5})
function pop=initpop2(popsize,BreakPipe_order)
pop=cell(popsize,1);%��һ��Ϊ�ܵ������򣬵�2��Ϊ�ܵ��޸�����
pop1=cell(popsize,2);%��һ��Ϊ�ܵ������򣬵�2��Ϊ�ܵ��޸�����
for i=1:popsize
[pop1{i,1}]=pipeDamage2priorityList(BreakPipe_order);%������ɼ�����
[pop1{i,2}]=pipeDamage2priorityList(BreakPipe_order);%��������޸�����
pop{i}=[pop1{i,1};pop1{i,2}];%������ϲ�
end
end