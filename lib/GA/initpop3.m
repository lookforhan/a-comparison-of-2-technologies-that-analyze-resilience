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
n_isolation = numel(Pipe_isolation);
n_replacement = numel(Pipe_replacement);
priority_isolation=zeros(n_isolation,popsize);%��һ��Ϊ�ܵ�������
priority_replacement=zeros(n_replacement,popsize);%��һ��Ϊ�ܵ��޸�����
for i = 1:popsize
    priority_isolation(:,i) = randperm(n_isolation);
    priority_replacement(:,i) = randperm(n_replacement);
end
pop_isolation_init = Pipe_isolation(priority_isolation)';
pop_replacement_init = Pipe_replacement(priority_replacement)';
% ���Ϊ����
% ÿһ��Ϊһ���޸���������
end