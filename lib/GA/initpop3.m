% 2018-1-1����������ʼ��Ⱥ�а����ܵ�������
%% ���� hanzhao@emails.bjut.edu.cn
%% 2017-12-19
% initpop.m�����Ĺ�����ʵ��Ⱥ��ĳ�ʼ����popsize��ʾȺ��Ĵ�С��chromlength��ʾȾɫ��ĳ���(��ֵ���ĳ���)��
% ���ȴ�Сȡ���ڱ����Ķ����Ʊ���ĳ���(�ڱ�����ȡ10λ)��
%�Ŵ��㷨�ӳ���
%Name: initpop.m
%��ʼ����Ⱥ
% pop=initpop2(20,{1;4;2;3;5})
function [pop_isolation_init,pop_replacement_init]=initpop3(popsize,Pipe_isolation,Pipe_replacement)
pop_isolation_init=cell(popsize,1);%��һ��Ϊ�ܵ�������
pop_replacement_init=cell(popsize,1);%��һ��Ϊ�ܵ��޸�����
for i=1:popsize
[pop_isolation_init{i,1}]=pipeDamage2priorityList2(Pipe_isolation);%������ɼ�����
[pop_replacement_init{i,1}]=pipeDamage2priorityList2(Pipe_replacement);%��������޸�����
end
end